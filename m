Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZGNDum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZGNDum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZGNDum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:50:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZGNDul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:50:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HT+6hKSyXLoT/sMR3QrZ95jm9CQvQkRa74J4L8bU2YrgSctdAwQShtP/gmsPrh/7t
	k9tYJcrVOt9+ASfCTMALw==
MIME-Version: 1.0
In-Reply-To: <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	 <4A5AA3E7.9070800@cn.fujitsu.com>
	 <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
	 <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jul 2009 20:50:33 -0700
Message-ID: <6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Blum <bblum@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 4:49 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> IIUC, this place, .../procs interface is not so important for performance
> as to being allowed this ugly conding.
>

It's not just the calling thread that suffers from the overhead -
we've seen performance hits on other processes on a machine due to the
TLB-shootdown overhead associated with vmalloc()/vfree().

Paul
