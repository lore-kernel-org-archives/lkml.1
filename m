Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXGXOXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXGXOXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbXGXOWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:22:55 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:57071 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbXGXOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:22:54 -0400
Message-ID: <46A6072D.7020807@aitel.hist.no>
Date: Tue, 24 Jul 2007 16:05:33 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: =?UTF-8?B?RGFuacOrbCBNYW50aW9uZQ==?= 
	<daniel.mantione@freepascal.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard programming needs root
References: <f79qnt$rn3$1@sea.gmane.org> <d120d5000707190817t62013ddcg966bd4e8c0ec116f@mail.gmail.com> <Pine.LNX.4.61.0707191748340.10291@idefix.wisa.be>
In-Reply-To: <Pine.LNX.4.61.0707191748340.10291@idefix.wisa.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniël Mantione wrote:
> Op Thu, 19 Jul 2007, schreef Dmitry Torokhov:
>
>   
>> Hi Daniel,
>>
>> On 7/14/07, Daniel Mantione <daniel.mantione@freepascal.org> wrote:
>>     
>>> Hello,
>>>
>>> A while back a patch was merged to make that only root can program the
>>> keyboard:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0b360adbdb54d5b98b78d57ba0916bc4b8871968
>>>
>>> Is this patch discussable? I think this patch isn't proper because of the
>>> following reasons:
>>>
>>> * Users can play games in many ways. They can configure the terminal
>>> settings, (remove the automatic line feed, disable the echo etc). They
>>> can
>>> load console fonts. They can still put the keyboard in raw mode, etc.
>>>       
>> Keyboard raw mode or disabling line echo may be annoying but you
>> really don't want someone leaving box after binding "rm -rf /" to a
>> backspace key...
>>     
>
> As I said, the proper solution to this problem is to restore the keyboard 
> in a known state after logout. There is no need for the kernel to change 
> behaviour. Many operating systems allow changing keyboard layout and can 
> because there is no need for it to be insecure.
>
> However, I can agree that in some cases, as per system policy, 
> administrators mays want to prevent this.
>
>   
>>> * All of these games can be prevented by making mingetty (or whatever 
>>>   getty is used) or PAM can put the console into a known state after 
>>>   logout.
>>> * All of these games are annoyances, system security is not 
>>>   compromised.
>>> * I do not see a problem with for example a French user doing a "loadkeys
>>> fr" if that allows hims to use the computer easier.
>>>
>>> Worst issue for me though, is that KDSBENT is needed to be able to catch
>>> keys like shift+tab, alt+fx, escape without delay. My application
>>> suddenly
>>> needs root permissions to work properly.
>>>       
>> Yes, if your application mucks with the console it has to be trusted...
>>     
>
> That is not really constructive: I don't want to muck with the console, I
> a working keyboard. Linux just just requires you to muck with the console if 
> you want a working keyboard. Many applications, Midnight Commander to name 
> one, work around Linux console limitations (try ctrl+arrows, 
> works as expected despite not supported by Linux).
>
> Now if you force applications to work around limitations, you have a 
> certain responsibility not to break them.
>
>   
>>> The alternative, semi raw mode,
>>> has the disadvantage that you need to implement your own keymaps (like
>>> X).
>>> In short, this change breaks applications.
>>>
>>>       
>> You may also try reading data directly from evdev devices... They are
>> normally privileged as well but usually user logged on console is
>> given access to them.
>>     
>
> evdev has the same problem as medium/full raw mode: You need your own 
> keyboard maps. This makes this solution not very practical.
>
> To make this discussion productive, I want to work towards a solution. I 
> don't mind how I can make the keyboard work as it should, I just want it 
> work. Think of the needs of a user interface, you walk through controls 
> using tab and shift+tab, put common commands under the function keys and 
> shift/control/alt combinations. Cursor control in an editor is done with 
> the navigation pad on your keyboard: arrows, home/end/pgup/pgdown, plus 
> shift/control/alt combinations with them.
>
> That is all, nothing fancy. Could the kernel support a way to do this?
>   
The normal way is to set permissions on the device in
question - give either root only or the logged-in user
write access as needed.

It seems to me that "loadkeys" uses /dev/tty / /dev/tty0
So set permissions on that as needed.

Helge Hafting
