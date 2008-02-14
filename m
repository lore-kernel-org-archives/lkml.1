Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbYBNPAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbYBNPAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYBNPAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:00:09 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35599 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYBNPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:00:07 -0500
Date: Thu, 14 Feb 2008 16:00:06 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Jasper Bryant-Greene <jasper@unix.geek.nz>,
       rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Subject: Re: Is there a "blackhole" /dev/null directory?
In-Reply-To: <p73pruz27mk.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0802141553400.694@fbirervta.pbzchgretzou.qr>
References: <20080214093051.7240852AB0E31@trashmail.net>
 <1202981957.10928.17.camel@phobos.jasper.bg> <p73pruz27mk.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 14 2008 10:46, Andi Kleen wrote:
>Jasper Bryant-Greene <jasper@unix.geek.nz> writes:
>>
>> This could be done fairly trivially with FUSE, and IMHO is a good use
>> for FUSE because since you're just throwing most data away, performance
>> is not a concern.

There is a much more interesting 'problem' with a "/dev/null directory".

Q: Why would you need such a directory?
A: To temporarily fool a program into believing it wrote something.

Q: Should all files disappear? (e.g. "unlink after open")
A: Maybe not, programs may stat() the file right afterwards and
   get confused by the "inexistence".

Q: What if a program attempts to mkdir /dev/nullmnt/foo to just
   create a file /dev/nullmnt/foo/barfile?
A: /dev/nullmnt/foo must continue to exist or be accepted for a while,
   or perhaps for eternity.

Been there, done that, -
http://dev.computergmbh.de/wsvn/misc_kernel/nullfs/trunk/nullfs.c -
and hit that wall of unanswerable questions.
