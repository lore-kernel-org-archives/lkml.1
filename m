Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYKTN0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYKTN0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYKTNZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:25:52 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:22119 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754238AbYKTNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:25:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VzD0LgCr279kBy/30fuOZfapF2D07MPkw6wvL9t9yGPVV2l0m5rVoWdiKlongB1ElqDP+gQyI5/NbLslKeX6Enjeo5A8MWuff5S/QA7rOJBGC0gX092SHNla/KbCzgqoMhuX67BtMsAyKTrt4kOue8NvuOeuLsA5FvuL5uJXT5Q=  ;
X-YMail-OSG: 9_X39KgVM1lOD5WF3n5TRY0jfClBc1._LOznyiuGH5s6cGPvfGPls5gtwYWp3CGV7UjwBfkPV5ATeL4pfUyjkPAVmLg3OSSS4QrGBBY6VZ.2LSlZUenO8wm7jq6QBOpP3zLEOkJmTum1tjvMq7TX.t5UZKduHuY3AtPszAcTfQTNqtlQ8BMSGCFLAcQs
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline kernel (specifically arm in our case)
Date: Fri, 21 Nov 2008 00:25:39 +1100
User-Agent: KMail/1.9.5
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, "Naval Saini" <navalnovel@gmail.com>,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com,
       "Ralf Baechle" <ralf@linux-mips.org>
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com> <200811201759.01039.nickpiggin@yahoo.com.au> <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com>
In-Reply-To: <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811210025.39568.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008 23:28, Dmitry Adamushko wrote:
> 2008/11/20 Nick Piggin <nickpiggin@yahoo.com.au>:
> > [ ... ]
> >
> > - The page is sent to the block layer, which stores into the page. Some
> >  block devices like 'brd' will potentially store via the kernel linear
> > map here, and they probably don't do enough cache flushing.
>
> btw., if someone is curious, here is another case of what may happen
> on VIPT systems when someone uses a "virtual" block device (like
> 'brd') as, heh, a swap :-)
>
> http://www.linux-mips.org/archives/linux-mips/2008-11/msg00038.html

Right... Now I'm lacking knowledge when it comes to devices, but I
think it is probably reasonable for the block device layer to ensure
the physical memory is uptodate after it signals request completion.

That is, there shouldn't be any potentially aliasing dirty lines.
Block devices which do any writeout via the kernel linear address
(eg. brd) should do a flush_dcache_page.

