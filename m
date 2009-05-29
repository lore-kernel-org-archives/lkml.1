Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZE2BPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZE2BPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZE2BPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:15:07 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:58401 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZE2BPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hqgA/ds0qwfnXZH2u+iHLoWUi9emaS8UucZvg/KqR3/W+TIwRE3iNdoC6G3B/p2deZ
         gTtYfZnW7hxwRLJwH7tlPC0VgD9TAVKaYi7M4oqSQhYpr6ESL7LWN+DDGY7cJgrVueQE
         9nt0y+YCbRc5ZqKxUIr0CvUHXU0ET17NyvYMw=
MIME-Version: 1.0
In-Reply-To: <1243553004.26735.4.camel@maxim-laptop>
References: <20081006194032.15992.8393.stgit@terra>
	 <20081006194308.15992.98682.stgit@terra>
	 <1243553004.26735.4.camel@maxim-laptop>
Date: Thu, 28 May 2009 21:15:05 -0400
Message-ID: <9e4733910905281815g376489c2ka11ffd43aac5221@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] Changes to core input subsystem to allow send and 
	receive of IR messages. Encode and decode state machines are provided for 
	common IR porotocols such as Sony, JVC, NEC, Philips, etc.
From: Jon Smirl <jonsmirl@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 7:23 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Mon, 2008-10-06 at 15:43 -0400, Jon Smirl wrote:
>> Received IR messages generate event in the input queue.
>> IR messages are sent using an input IOCTL.
>
> Another question.
>
> So input device sends its events as a special event type?
> This would mean that none of current drivers will be able to pick these
> events.

There is a later version of this patch set that uses configfs to map
IR events into keystrokes on the /dev/input device. I have later
additions to the code that haven't been posted. They fix issues with
calling configfs at interrupt time.

-------------------------------------------

I posted V4 of my in-kernel IR system to LKML.  It supports mapping
from IR events to key strokes now.
http://lkml.org/lkml/2008/11/5/233

To do the mapping it uses configfs (part of the kernel).  The main
directory is remotes. You use a shell script to build mappings between
the IR event and key stroke.

mkdir /config/remotes/sony
 -- this creates a new evdev device
mkdir remotes/sony/one
echo 7 >remotes/sony/one/procotol
echo 264 >remotes/sony/one/command
echo 2 >remotes/sony/one/keycode

This transforms a button push of 1 on my remote into a key stroke for KEY_1

 *   configfs root
 *   --remotes
 *   ----specific remote
 *   ------keymap
 *   --------protocol
 *   --------device
 *   --------command
 *   --------keycode
 *   ------repeat keymaps
 *   --------....
 *   ----another remote
 *   ------more keymaps

You can map the 1 button from multiple remote to KEY_1 if you want. Or
you can use a single remote to create multiple virtual keyboards.

I'm always looking for help with this code. I've implemented support
for my embedded GPIO based receiver and Microsoft MCEUSB. I'd really
like to see IR added to existing Linux input family of keyboards,
mice, joystick, tablet, touchscreen and gameport.


>
>
> I think that input device should have better configuration support, like
> generic way to set a keymap (raw->keycode) for a device, and the IR
> timing can be set too.
> And send normal keypreses.
>
> Regards,
>        Maxim Levitsky
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
