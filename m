Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYKOQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYKOQKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 11:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYKOQKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 11:10:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:14908 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYKOQKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 11:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ohAlYS02RqaMbJ+PMXJYg864aHOYFCRycavmIv3IrrYrIgw2zYATv2uRLeNAv2CGcC
         sBWfa3qOrlKVzyOTTnBLTFoGm/reJwfPVU9Zsl/RdiafyAgDKXzTYi8hUDHWZDgtbHQr
         P3LjdlzXrkngDxx95jRK+Ctj2EyOCUl/lr4AA=
Message-ID: <3aaafc130811150810s49c09a46o7de0da3d07fe9bb2@mail.gmail.com>
Date: Sat, 15 Nov 2008 11:10:01 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: In-kernel IR remote control support
Cc: "Christoph Bartelmus" <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       jonsmirl@gmail.com
In-Reply-To: <20081115115859.GA1572@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7f0c6fc9-556c-41a1-9750-ffb3455589ab@35g2000pry.googlegroups.com>
	 <ApnRmVyojFB@christoph> <20081115115859.GA1572@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 6:58 AM, Pavel Machek <pavel@suse.cz> wrote:
> On Thu 2008-11-13 00:09:00, Christoph Bartelmus wrote:
>> Hi,
>>
>> on 12 Nov 08 at 14:39, J.R. Mauro wrote:
>> [...]
>> > On Wed, Nov 5, 2008 at 3:07 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>> >> On Wed, Nov 5, 2008 at 2:59 PM, J.R. Mauro <jrm8...@gmail.com> wrote:
>> >>> On Wed, Nov 5, 2008 at 2:47 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>> >>>> New release of in-kernel IR support implementing evdev support. The goal
>> >>>> of in-kernel IR is to integrate IR events into the evdev input event
>> >>>> queue and maintain ordering of events from all input devices. Still
>> >>>> looking for help with this project.
>>
>> >>> (Forgive me if this has already been asked or dealt with)
>>
>> >>> Have you contacted the LIRC developers? Is there any overlap between
>> >>> your projects?
>>
>> >> The LIRC people know about this. Pieces of the code are coming from
>> >> the LIRC source base and being reworked for kernel inclusion.
>>
>> > Great, it's nice to see there's cooperation.
>>
>> LOL. There's just a small omission from Jon's side...
>> Yes, LIRC people know about this. And Jon has a no-go from me.
>>
>> Decoding IR protocols in-kernel is the wrong way IMHO and this will not be
>> supported by LIRC as long as I maintain LIRC.
>
> Time to fork lirc...?
>
> Can you elaborate?  I don't see why IR remotes deserve special
> handling. I'd expect to just plug in the receiver and have it work as
> /dev/input/*.
>
>> It's simply not possible to decode all existing IR protocols and LIRC just
>> stores the timing data for these protocols as-is without trying to decode
>> them. With the in-kernel decoding approach these remotes cannot be
>> supported. I'm not willing to sacrifice the support for these even though
>> they only consist of a very small fraction of remotes in use.
>
> So you make it suck for everyone just because few obscure IR
> remotes. Perfect enemy of good, I'd say :-(.
>
> Can we merge the common ones into the kernel, while still keeping the
> obscure ones in userspace using uinput or something?
>
> I don't see why Jon's work bothers you. He's trying to do the right
> support for the common remotes. That seems like a net plus to me, and
> you can still keep the obscure ones in userland.

We manage to have both kernelspace and userspace USB drivers. I think
that would be the right approach here, especially since whole classes
of some remotes change model to model. Apple remotes are an example of
this: you have to figure out what different signal each new model
sends and it is really nice for the user to be able to do this and put
it in a config file and not have to wait for the next kernel version.

Finding the middle ground here is probably the sanest course.

>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
