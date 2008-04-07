Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbYDGRs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbYDGRs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 13:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYDGRst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 13:48:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25241 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbYDGRst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 13:48:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cjiTSE5Tme7VbDtJs+RVoO5b7ERIoOUHebxIUJPcSfi+yYdLmNf0aPKIRERzYvf1n
	n29RHTQOZCdnP3j2TojZA==
Message-ID: <6599ad830804071048u5e0687dfy4313467fd95dab1c@mail.gmail.com>
Date: Mon, 7 Apr 2008 10:48:23 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Disable the memory controller by default
Cc: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Pavel Emelianov" <xemul@openvz.org>, hugh@veritas.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47FA10BB.9000305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407115137.24124.59692.sendpatchset@localhost.localdomain>
	 <20080407120340.GB16647@one.firstfloor.org>
	 <47FA0D85.201@linux.vnet.ibm.com>
	 <2f11576a0804070516r185bff87t449c315bd7787c7e@mail.gmail.com>
	 <47FA10BB.9000305@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 5:16 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  No, it is not all bad. That can be done, but we need to guard against a usage like
>
>  cgroup_disable=memory cgroup_enable=memory
>
>  The user will probably get what he/she deserves for it.

I don't think we need to guard against that. It seems perfectly valid
to have a lilo config with

  append="cgroup_disable=memory"

and then want to boot with the memory controller enabled you can do

  lilo -R <image> cgroup_enable=memory

The kernel command line will then look like

  "... cgroup_disable=memory cgroup_enable=memory"

and the last switch should win.

Paul
