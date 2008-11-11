Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKKVac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKKVac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYKKVaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:30:22 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42753 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYKKVaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:30:21 -0500
Date: Tue, 11 Nov 2008 13:30:10 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: Boot hang sizing transparent PCI-to-PCI
	bridgesinceafter 2.6.25-r7.
Message-ID: <20081111213009.GA7072@us.ibm.com>
References: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva> <49180973.6080808@gmail.com> <20081110175815.GA7650@us.ibm.com> <D913A682D10DBA4097B5D068D281B09B0266F9B0@S1128EXE.bbva.igrupobbva> <49196DA1.3040104@gmail.com> <D913A682D10DBA4097B5D068D281B09B0266F9CB@S1128EXE.bbva.igrupobbva>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D913A682D10DBA4097B5D068D281B09B0266F9CB@S1128EXE.bbva.igrupobbva>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 12:43:28PM +0100, GARCIA DE SORIA LUCENA, JUAN JESUS wrote:
> > -----Original Message-----
> > From: Jiri Slaby [mailto:jirislaby@gmail.com] 
> >
> > GARCIA DE SORIA LUCENA, JUAN JESUS napsal(a):
> > > resource_size_t type
> > > (defined in linux/types.h) being u64. Perhaps it's u32 in a 32 bit 
> > > architecture.
> > 
> > Unless you have RESOURCES_64BIT=y which is the default on x86_32 now.
> 
> Ugh. Knowing this will save me from downloading, burning and testing the
> 32 bit Ubuntu distro, whose 2.6.27 kernel will surely use that default
> configuration.
> 
> I'll perform more tests, with more debug kprintf()'s, anyway.
> 
> Do you remember if the cases Gary's patches were trying to fix included
> ranges rolling past the 32-bit address limit (end address below start
> address)?

No, my patches were not trying to fix anything like that.

I looked at the `lspci -vvv` output for some transparent bridges on
one of our systems and found that the messed up looking ranges are
not unique to your system.  We also see that on our systems.  I checked
the lspci code and found that the displayed ranges are based on base
and limit register values obtained directly from PCI config space 
for the device.  I also noticed that -vvv it will display values even
if they do not represent valid ranges such as you might expect for the
contents of base and limit registers on transparent bridges.  This
caused me to peek at the lspci man page which says:
"-vvv   Be even more verbose and display everything we are able
       to parse, even if it doesn’t look interesting at all
       (e.g., undefined memory regions)."
You must be getting some of that "even if it doesn't look interesting
at all" stuff. :)

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

