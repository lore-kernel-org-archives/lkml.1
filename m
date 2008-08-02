Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYHBE1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYHBE1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 00:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYHBE1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 00:27:10 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:31163 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750783AbYHBE1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 00:27:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KAirq0fxnGGhaP8mTzZXxn6LnTcfMRrwbXI49WDop4ijSufoUl01WEl0tCXx/szdTCsoGhXvanPS3bZ2f7RKgjiK6S06jv0mrs6l3ioWjJdFDOJk/jP/+Pwm2ci6B3fHe3sF1a9iyFVQWCMHfMUSzGEP7jKHEGSBOGahOxGLeOE=  ;
X-YMail-OSG: S7JvdEgVM1kt1wcDjhHk.GbORWkzFz_Me0Xx8ppCvXDOFJz0iX.23vxq74j0IoieAt8nb5dzq7GcM5S2MlHhkhFCSDNH.YgWhHnocgpnTPK_YRUWewIinpT1LZGcXpGtMM4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch v3] splice: fix race with page invalidation
Date: Sat, 2 Aug 2008 14:26:50 +1000
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <200808011122.51792.nickpiggin@yahoo.com.au> <E1KOzMt-0003fa-Ah@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KOzMt-0003fa-Ah@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021426.50436.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 August 2008 04:28, Miklos Szeredi wrote:
> On Fri, 1 Aug 2008, Nick Piggin wrote:
> > Well, a) it probably makes sense in that case to provide another mode
> > of operation which fills the data synchronously from the sender and
> > copys it to the pipe (although the sender might just use read/write)
> > And b) we could *also* look at clearing PG_uptodate as an optimisation
> > iff that is found to help.
>
> IMO it's not worth it to complicate the API just for the sake of
> correctness in the so-very-rare read error case.  Users of the splice
> API will simply ignore this requirement, because things will work fine
> on ext3 and friends, and will break only rarely on NFS and FUSE.
>
> So I think it's much better to make the API simple: invalid pages are
> OK, and for I/O errors we return -EIO on the pipe.  It's not 100%
> correct, but all in all it will result in less buggy programs.

That's true, but I hate how we always (in the VM, at least) just brush
error handling under the carpet because it is too hard :(

I guess your patch is OK, though. I don't see any reasons it could cause
problems...
