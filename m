Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYAIAlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYAIAlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYAIAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:41:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:52443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYAIAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:41:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Wed, 9 Jan 2008 01:40:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       apw@shadowen.org
References: <20080108164015.GC31504@one.firstfloor.org> <20080108185255.GA4627@martell.zuzino.mipt.ru> <20080108191843.GA1004@one.firstfloor.org>
In-Reply-To: <20080108191843.GA1004@one.firstfloor.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801090140.58864.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19SMrLrtzGWSN7IJ2Lk32K771/sYAjAg0D1woI
 2765dNbK4vcOR/egAd3uI6kRisoim80651DJkvFbPnXvtgBpYJ
 edPJqjamA8yTRGbkBgBpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008, Andi Kleen wrote:
> > Thanks, Andi! I think it'd very useful change.
> 
> Reminds me this is something that should be actually flagged
> in checkpatch.pl too
> 
> Andy, it would be good if checkpatch.pl complained about .ioctl = 
> as opposed to .unlocked_ioctl = ...

This is rather hard, as there are different data structures that
all contain ->ioctl and/or ->unlocked_ioctl function pointers.
Some of them already use ->ioctl in an unlocked fashion only,
so blindly warning about this would give lots of false positives.
 
> Also perhaps if a whole new file_operations with a ioctl is added
> complain about missing compat_ioctl as a low prioritity warning?
> (might be ok if it's architecture specific on architectures without
> compat layer)

Also, not every data structure that provides a ->ioctl callback
also has a ->compat_ioctl, although there should be fewer exceptions
here.

	Arnd <><
