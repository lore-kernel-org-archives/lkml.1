Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbYEEVOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbYEEVOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYEEVN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:13:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:40884 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYEEVN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R62o3dxmEkbamal/IuLPMpO9UJ3b4yIP91bUJ7tRKnuJGRRKp9lKQfAHDAdqOCUHc4OUVE4regJA477Vz10Q/xAKXwYlK2LqUeaGODkR004DnQeNQLVbbwlm2xnwJfn9jx0UVOBr2zzKNwautg6LOZdTtUejx/Per7DopqmEMB4=
Message-ID: <52950c3f0805051413r7d41c4f0tcdc21dc7938d05e8@mail.gmail.com>
Date: Mon, 5 May 2008 17:13:46 -0400
From: "Timur Alperovich" <timur.alperovich@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: exported version of page_is_ram?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080505125035.719feaa5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <52950c3f0805051058t5d3447c2r3ae8e77cf0166b00@mail.gmail.com>
	 <20080505125035.719feaa5@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I put the whole driver on pastebin http://pastebin.com/m24c50118
For now I tried to use the code for page_is_ram in there, only to
realize that e820 struct is also not exported. Is there a way to do
this with the existing code in the kernel, since I'd like the code to
run on older 2.6 kernels as well?

Timur

On Mon, May 5, 2008 at 3:50 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> On Mon, 5 May 2008 13:58:59 -0400
>  "Timur Alperovich" <timur.alperovich@gmail.com> wrote:
>
>  > Hi,
>  >
>  > I need to check if a given page is in ram or not. It seems that
>  > page_is_ram does the trick, but since it's not exported, I end up with
>  > "unknown symbol" errors when I try to insert the module. I'm trying to
>  > hash the contents of every page in physical memory, and iterating
>  > through pages from 0 to num_physpages, while checking if they are
>  > actually in ram seemed reasonable. Is there a better way to do it or
>  > is there another function rather than page_is_ram that can do the
>  > trick?
>
>  sounds like the right way is to make a "for each ram page" function
>  in the core, export_symbol_gpl that so that you can then use that...
>  We could even make it scale and numa friendly in the core that way.
>
>  Do you have a url for your code?
>
