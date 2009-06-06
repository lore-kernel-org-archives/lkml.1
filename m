Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZFFFoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZFFFoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 01:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZFFFoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 01:44:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:53384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZFFFoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 01:44:30 -0400
Subject: Re: [PATCH 17/39] kbuild: fix header export when __ASSEMBLY__ is
 used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <200906060041.07600.arnd@arndb.de>
References: <20090605233720.GA13588@uranus.ravnborg.org>
	 <1244245377-17441-17-git-send-email-sam@ravnborg.org>
	 <200906060041.07600.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 11:15:44 +0530
Message-Id: <1244267144.2449.29.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam, Russell,

On Sat, 2009-06-06 at 00:41 +0000, Arnd Bergmann wrote:
> On Friday 05 June 2009 11:42:35 pm Sam Ravnborg wrote:
> > Because it does not know __ASSEMBLY__ it does not
> > detect that htis is not for userspace.
> > This caused too much code to be exported, and headers_check barfed
> > over this code.
> > 
> > For arm this fixes following "make headers_check" warning:
> > /usr/include/asm/hwcap.h:29: extern's make no sense in userspace
> 
> Are you sure that this is safe for all user space? If a user application
> for instance includes asm/signal.h or asm/types.h from assembly (for
> whatever reason), it now breaks.
> 
> I can't think of a good reason why anyone would do such a thing,
> but it used to be possible.
> 

I also want to add :

__KERNEL__ and __ASSEMBLY__ is used for specific purpose, please do not
mix them otherwise it leads to confusion and people will start using
interchangeably. It seems to me that you are introducing Pink traffic
light for stoppage so my request is to respect the protocols.

I do not think it is safe and this will screw some user-space apps and
then later on kernel.

Thanks,
--
JSR


