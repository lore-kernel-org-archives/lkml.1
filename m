Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXBETmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXBETmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933420AbXBETmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:42:10 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22557 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbXBETmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:42:08 -0500
In-Reply-To: <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org> <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org> <20070203082308.GA6748@elte.hu> <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com> <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 14:41:31 -0500
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The "result" of one async operation is basically a cookie and a result
> code. Eight or sixteen bytes at most.

s/basically/minimally/

Well, yeah.  The patches I sent had:

struct asys_completion {
         long            return_code;
         unsigned long   cookie;
};

That's as stupid as it gets.

> IMO, before going wacko designing
> complex shared userspace-kernel result buffers, I think it'd be better
> measuring the worth-value of the thing ;)

Obviously, yes.

The potential win is to be able to have one place to wait for  
collection from multiple sources.  Some of them might want more data  
per event.  They can always indirect out via a cookie pointer,  sure,  
but at insanely high message rates (10gige small messages) one might  
not want that.

See also: the kevent thread.

- z
