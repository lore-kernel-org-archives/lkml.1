Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbZKXNbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbZKXNbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932858AbZKXNby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:31:54 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:50438 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838AbZKXNbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XkNhmtJOi9dD8T8q9hLsyH59HonB5eaBg96JIP8HFSmfu8bYa+5mAMl54pbO2m8teO
         Naec5XSKIAToJsO++g8EF/op6DYdsNmUujAMj9lhTPDfGWrpy7DU+GGfNBvSDJ4TRnzR
         RbT8cQg+DsgGad8tWH4uN44Gv+kOUT7mHCbAo=
MIME-Version: 1.0
In-Reply-To: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
Date: Tue, 24 Nov 2009 19:01:54 +0530
X-Google-Sender-Auth: de8da2c5babbb5c5
Message-ID: <661de9470911240531p5e587c42w96995fde37dbd401@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH -mmotm] memcg: avoid oom-killing innocent task in 
	case of use_hierarchy
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       stable <stable@kernel.org>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:27 AM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> task_in_mem_cgroup(), which is called by select_bad_process() to check whether
> a task can be a candidate for being oom-killed from memcg's limit, checks
> "curr->use_hierarchy"("curr" is the mem_cgroup the task belongs to).
>
> But this check return true(it's false positive) when:
>
>        <some path>/00          use_hierarchy == 0      <- hitting limit
>          <some path>/00/aa     use_hierarchy == 1      <- "curr"
>
> This leads to killing an innocent task in 00/aa. This patch is a fix for this
> bug. And this patch also fixes the arg for mem_cgroup_print_oom_info(). We
> should print information of mem_cgroup which the task being killed, not current,
> belongs to.
>

Quick Question: What happens if <some path>/00 has no tasks in it
after your patches?

Balbir
