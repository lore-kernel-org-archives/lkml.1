Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYCNUVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYCNUVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYCNUVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:21:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:55821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYCNUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:21:12 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Keys get stuck
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, David Newall <davidn@davidnewall.com>,
       Jiri Kosina <jkosina@suse.cz>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 14 Mar 2008 21:20:41 +0100
References: <a6meN-2aj-39@gated-at.bofh.it> <a6wxo-1xY-1@gated-at.bofh.it> <a6wQO-1YG-1@gated-at.bofh.it> <a6Zgb-5Hj-55@gated-at.bofh.it> <a7iiO-2fq-39@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JaGOQ-0003km-7S@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19Bvlq5qRxRfgEGjoNQ4zYflPz8g4/KrQ3Vv1V
 e1YOcc3zQpm7Vv6XKj2mgJpsnyI2MPI+fdoL2GWf7KgpWX/aas
 rYUA2OUiF72LnU2xSIPrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Mar 13, 2008 at 06:14:26PM +0100, Pavel Machek wrote:

>> hw is proper place to implement autorepeat, and along with some
>> buffering, it has chance to work. Kernel is not real-time, and X are
>> definitely not real-time, while autorepeat is real-time operation.
>> 
>> It actually mostly works in ps/2 case. Buffer in hardware means that
>> pretty big interrupt delays can be tolerated without problems.
> 
> So does the keyboard events generate something like this then:
> 
> KEY_x_DOWN
> KEY_x_REPEAT
> KEY_x_UP
> 
> If so then X certainly could get all the keyboard information I imagine
> it needs from the kernel, but otherwise I am not sure how it could.  A
> repeated series of key down events are not enough since some keys you
> don't want repeated you just want to know when the key is held down and
> when it isn't.

You just need a timestamp for each event, and you can get a timestamp for
each event (as far as I read in this thread). Using the current time while
processing the event is plain stupid.

