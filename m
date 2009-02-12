Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbZBLUY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbZBLUY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZBLUYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:24:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35695 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZBLUYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:24:15 -0500
To: John Ogness <dazukocode@ogness.net>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 5/5] VFS: DazukoFS, stackable-fs, file access control
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<86skmvfhx6.fsf_-_@johno.fn.ogness.net>
	<86ocxjfhv7.fsf_-_@johno.fn.ogness.net>
	<86k587fhto.fsf_-_@johno.fn.ogness.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 12 Feb 2009 12:24:20 -0800
In-Reply-To: <86k587fhto.fsf_-_@johno.fn.ogness.net> (John Ogness's message of "Tue\, 03 Feb 2009 20\:20\:35 +0100")
Message-ID: <m1eiy3csjv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: dazukocode@ogness.net, alan@lxorguk.ukuu.org.uk, hch@infradead.org, eparis@redhat.com, malware-list@lists.printk.net, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Ogness <dazukocode@ogness.net> writes:

> Patch 5: Creates /dev/dazukofs.ign as an (optional) mechanism for any
>          processes to hide themselves from DazukoFS file access
>          control.

Your reference counting is broken.  What happens if a process exits
and you are ignoring it. 

When fixing this use a struct pid * not struct task_struct *.  That
is what struct pid is for there is no need to pin the entire task
struct into memory after the process exits just because
you decided to ignore it.

Eric
