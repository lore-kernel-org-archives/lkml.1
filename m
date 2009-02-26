Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbZBZXpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbZBZXpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZBZXpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:45:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbZBZXpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:45:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC v2] virtio: add virtio-over-PCI driver
Date: Fri, 27 Feb 2009 00:44:52 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
References: <20090224000002.GA578@ovro.caltech.edu> <200902262334.33778.arnd@arndb.de> <20090226231742.GB19959@ovro.caltech.edu>
In-Reply-To: <20090226231742.GB19959@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902270044.53683.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uUghHA6mmPBWuaE43/kM9M9jkGzICXxjod2G
 D7CphHif6ZhkJyNqxEov/GxSBW2j2Hk6S5XXsQZ7k1p3yI8eJn
 2bq4j7gWECq2Kmbg3A38Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Ira Snyder wrote:
> On Thu, Feb 26, 2009 at 11:34:33PM +0100, Arnd Bergmann wrote:
> > I guess the best option for doing it in Linux then would be to have
> > a board control driver (not sure if this already exists) that exports
> > high-level functions to set up the inbound and outbound windows.
> > 
> 
> Nothing like it exists. The OF device tree doesn't even describe these
> registers. The code in arch/powerpc/sysdev/fsl_pci.c uses some registers
> near these, but it gets their address by masking the low bits off the
> addresses from the device tree and adding the offsets of the new
> registers. Nasty.
> 
> I'll do this for now:
> 1) Get the message unit registers from my device tree
> 2) Encapsulate all use of get_immrbase() to a single function
> 
> That way it could be easily replaced in the future when something more
> suitable comes along.

Ok. However, I don't expect this to get fixed magically. Ideally,
you would start a new file for the board control in arch/powerpc/sysdev
and export the function from there, otherwise you do it the way you
suggested.
Then we can tell the fsl_pci and other people to use the same
method and source file to access the board control.
> 
> I didn't think about this at all. This driver could be used to boot a
> (guest) system over NFS, so in that case there isn't a userspace running
> yet, to allow configuration. This is essentially my use case, though I
> haven't implemented it yet.
> 
> Also, I hate designing user interfaces :) Any concrete suggestions on
> design would be most welcome.

Don't worry about it for now, just put all the hardcoded virtio_net
specific stuff into a file separate from the hardware specific
files so that we have a nice kernel level abstraction to build a
user abstraction on top of.

	Arnd <><
