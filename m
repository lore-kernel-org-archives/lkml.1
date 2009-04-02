Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZDBLYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZDBLYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZDBLYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:24:39 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:21300 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751043AbZDBLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:24:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ejGoPE+0opTZLR7xxA2jzddTOJinowMFksMaKZngUVokLWAg7qklXIBJNmn1ugxadAtC70VdUYoixOab1skSqAySYUAJndM2JxmBPm/sWGB1y6MBSLFhL5KxJSl70N16spuTY/bwV+Wv5WWIWFcZ9X2idmsbeKLBKdaWbyNACrI=  ;
X-YMail-OSG: gTvnNfwVM1nz.Qh7BIjBIEC0eVZVIZhdfTXT4SMfj07wqPRw3sB.NmAAtQ1oe9AznWKeA5cUKW2TVapsGwMlPIAJJfDfRphKjXzdIAU5Mbl6thg1WaA11au9.9hUR747dyC8pOpm0_O9Y500eI8wK7GOJgRZGJCOcF4_zeNo.aboBD4JtpgTomI3YD.x2kA7fqWaRsBix732Yj2w8dwSspqSkwVG.63N61LIyQN0wB1tYGnSCAXIjEE0GpphDlKlXe9asqBmY9vFXcKtXrT5repMIv.g7dyfRKbmTaw99akGMS6Ewvkq
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ying Han <yinghan@google.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Thu, 2 Apr 2009 22:24:29 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jan Kara <jack@suse.cz>, "Martin J. Bligh" <mbligh@mbligh.org>,
       linux-ext4@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090324173511.GJ23439@duck.suse.cz> <604427e00904011536i6332a239pe21786cc4c8b3025@mail.gmail.com>
In-Reply-To: <604427e00904011536i6332a239pe21786cc4c8b3025@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022224.31060.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009 09:36:13 Ying Han wrote:
> Hi Jan:
>     I feel that the problem you saw is kind of differnt than mine. As
> you mentioned that you saw the PageError() message, which i don't see
> it on my system. I tried you patch(based on 2.6.21) on my system and
> it runs ok for 2 days, Still, since i don't see the same error message
> as you saw, i am not convineced this is the root cause at least for
> our problem. I am still looking into it.
>     So, are you seeing the PageError() every time the problem happened?

So I asked if you could test with my workaround of taking truncate_mutex
at the start of ext2_get_blocks, and report back. I never heard of any
response after that.

To reiterate: I was able to reproduce a problem with ext2 (I was testing
on brd to get IO rates high enough to reproduce it quite frequently).
I think I narrowed the problem down to block allocation or inode block
tree corruption because I was unable to reproduce it with that hack in
place.

