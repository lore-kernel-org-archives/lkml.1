Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYDCLH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYDCLH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 07:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYDCLHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 07:07:15 -0400
Received: from mailout04.t-online.de ([194.25.134.18]:33311 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbYDCLHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:07:14 -0400
Message-ID: <47F4BA31.1080702@t-online.de>
Date: Thu, 03 Apr 2008 13:06:25 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080229)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       David McCullough <David_Mccullough@securecomputing.com>,
       LKML <linux-kernel@vger.kernel.org>, Bryan Wu <Bryan.Wu@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: nommu: handling anonymous mmap clearing in userspace rather than
 kernel
References: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>	 <5516.1207146014@redhat.com>	 <8bd0f97a0804020747r2d7c2802pa18cf08eced3821b@mail.gmail.com>	 <47F3A02B.5070302@t-online.de> <8bd0f97a0804020807o21f69b7due910563b9dad03e8@mail.gmail.com>
In-Reply-To: <8bd0f97a0804020807o21f69b7due910563b9dad03e8@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: bjPqPUZFwh0trOepmgmIu66nBd+Zw6Gz-j9cXznN26wabPUiH7e8iUsTWSfPTUTgSk
X-TOI-MSGID: 7eca4172-f1db-481f-b41d-6ac1abece122
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:

> i also expected MAP_UNINITIALIZE to be unacceptable to LKML.  and
> afaik, there doesnt seem to be a way to distinguish in the kernel
> whether the call is coming from userspace or kernel space, so the
> memset() call will still be called for the kernel.  ideally the code
> would read:
> if (!kernel && !(flags & MAP_UNINITIALIZE))
>     memset(base, 0, len);

Have you examined all callers in the kernel whether they can take 
uninitialized memory?  (Your code doesn't match your description btw, so 
I'm only guessing what you actually want to achieve.)

Really, if MAP_UNINITIALIZE is unacceptable, then that's too bad and 
we'll carry it as a local patch, but all the other proposed mechanisms 
are non-solutions because they break an established interface.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
