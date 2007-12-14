Return-Path: <linux-kernel-owner+w=401wt.eu-S934216AbXLNQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbXLNQRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765100AbXLNQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:17:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbXLNQQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:16:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: RFC: remove __read_mostly
Date: Fri, 14 Dec 2007 17:16:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20071213222044.GH21616@stusta.de> <p73bq8ugrez.fsf@bingen.suse.de> <20071213224111.GI21616@stusta.de>
In-Reply-To: <20071213224111.GI21616@stusta.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712141716.47742.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+HtS7cJbWXSxISX5Cc/SXo4AThpd7nVoVADdv
 bWiK6ew8bxD2YR8RSbFLNiSRCUTUQSrJIMHOZYh5LRfLDAWd9V
 ZIJqgtQxd5cwlMDYdVuuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 December 2007, Adrian Bunk wrote:
> On Thu, Dec 13, 2007 at 11:29:08PM +0100, Andi Kleen wrote:
> > Adrian Bunk <bunk@kernel.org> writes:
> > >
> > > -rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
> > > -rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux
> > 
> > File sizes are useless -- check size output.
> 
>     text    data     bss      dec     hex filename
> 29268488 3697961 5222400 38188849 246b731 vmlinux.old
> 29268435 3685565 5228784 38192784 246c690 vmlinux

Just to make sure everyone interprets this correctly:

The file size in the first example suggests a 8552 byte
(0.02%) size improvement for removing __read_mostly.

The size output shows a -3935 byte (0.01%) size penalty
instead, much smaller because data that was moved out to
the .data.read_mostly section from .bss now takes space
in the binary but won't consume more RAM.

Since 'size' does not take any sections except text, data and
bss into account, its output is more often than not also
misleading, but at least it shows that the footprint is likely
to get larger without __read_mostly rather than smaller.

	Arnd <><
