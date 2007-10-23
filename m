Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbXJWTnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbXJWTnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJWTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:43:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46250 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752178AbXJWTnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:43:16 -0400
Date: Tue, 23 Oct 2007 21:43:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: drivers/net/wireless/rt2x00/: struct data_desc strangeness
Message-ID: <20071023194344.GX30533@stusta.de>
References: <20071014175032.GI4211@stusta.de> <200710142106.20409.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200710142106.20409.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 09:06:20PM +0200, Ivo van Doorn wrote:
> On Sunday 14 October 2007, Adrian Bunk wrote:
> > drivers/net/wireless/rt2x00/rt2x00ring.h contains the following:
> > 
> > <--  snip  -->
> > 
> > ...
> > /*
> >  * data_desc
> >  * Each data entry also contains a descriptor which is used by the
> >  * device to determine what should be done with the packet and
> >  * what the current status is.
> >  * This structure is greatly simplified, but the descriptors
> >  * are basically a list of little endian 32 bit values.
> >  * Make the array by default 1 word big, this will allow us
> >  * to use sizeof() correctly.
> >  */
> > struct data_desc {
> >         __le32 word[1];
> > };
> > ...
> > /*
> >  * TX/RX Descriptor access functions.
> >  */
> > static inline void rt2x00_desc_read(struct data_desc *desc,
> >                                     const u8 word, u32 *value)
> > {
> >         *value = le32_to_cpu(desc->word[word]);
> > }
> > 
> > static inline void rt2x00_desc_write(struct data_desc *desc,
> >                                      const u8 word, const u32 value)
> > {
> >         desc->word[word] = cpu_to_le32(value);
> > }
> > ...
> > 
> > <--  snip  -->
> > 
> > I haven't checked whether it might work in all cases, but passing 
> > non-zero values as second parameter to rt2x00_desc_{read,write}()
> > (as is done in many cases) is even in the best case bad coding style.
> 
> Access to the array is correct, even with non-zero values the code that is
> reading/writing to the array knows the exact size of the descriptor. Within
> rt2x00 are however 5 drivers who have different descriptor sizes. That means
> I can't create a structure which has the correct array length.
> 
> The structure itself is just a simple map over preallocated memory
> (skb->data in case of USB or dma in case of PCI).
> 
> So possible solutions would be:
>  - remove struct data_desc and make it a void* or __le32*
>    This is at the cost of code readibility since the above pointers
>    have less meaning then a pointer to a structure which can be nicely
>    documented.
>...

The worst is a wrong meaning.
__le32 word[1] is an array with _one_ element.

And an __le32* can be used as an array.

> Ivo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

