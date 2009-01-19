Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZASI36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZASI36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZASI3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:29:49 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:52232 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZASI3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tfEzIsz3+p+gZuIw1L4P5hTMauAXqAa1lch1j2gzz0gJNGySzQ4s8PtHUmy3nAQXky
         TgO2WP8EUO9NXd5jlOQFhFDgy17+SthN53TZkmXfhZrvnr3SGpzMRysDkUrGkzlIMcJx
         +bk2khCFwSAkFHz2/3tqJzPy6JTaeFSAT1jO0=
MIME-Version: 1.0
In-Reply-To: <1232352639.5570.8.camel@brick>
References: <20090117231925.GA28055@redhat.com>
	 <20090118020038.GA17489@cmpxchg.org> <49738E4B.1030200@gmail.com>
	 <497432B0.1080201@s5r6.in-berlin.de>
	 <49743444.8070206@s5r6.in-berlin.de> <1232352639.5570.8.camel@brick>
Date: Mon, 19 Jan 2009 09:29:46 +0100
Message-ID: <a2776ec50901190029s28e663c6m1dc277484e143ac2@mail.gmail.com>
Subject: Re: [PATCH] fbmem: fix copy_from/to_user() with mutex held
From: Andrea Righi <righi.andrea@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 9:10 AM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Mon, 2009-01-19 at 09:05 +0100, Stefan Richter wrote:
>> Stefan Richter wrote:
>> > Andrea Righi wrote:
>> >> +struct fb_info *get_fb_info(struct fb_info *info)
>> >> +__acquires(&info->lock)
>> >> +{
>> >> +  mutex_lock(&info->lock);
>> >> +  if (!info->fbops) {
>> >> +          mutex_unlock(&info->lock);
>> >> +          return NULL;
>> >> +  }
>> >> +  return info;
>> >> +}
>> >> +
>> >> +void put_fb_info(struct fb_info *info)
>> >> +__releases(&info->lock)
>> >> +{
>> >> +  mutex_unlock(&info->lock);
>> >> +}
>> >> +
>> >
>> > These are IMO bad function names.
>>
>> PS:  The return value of the mutex_lock wrapper is also bad.  A bool or
>> int would IMO be clearer, similar to the return value of mutex_trylock.
>
> That, and there is no possible way to get the sparse annotations right
> for that function, which means you'll get no help from sparse in lock
> checking.
>
> So I'd suggest just opencoding these where needed instead of the
> wrappers.
>
> Harvey
>

OK, thanks for all the suggestions. I'll fix everything and repost a
new patch ASAP.

-Andrea
