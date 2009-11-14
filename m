Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbZKNSTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbZKNSTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 13:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZKNSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 13:19:09 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45088 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZKNSTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 13:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ck0k+AQ8qKmQUxMrBCMHsrQwIngIhHaKjvQRkdLB5cgUXVIgDsM3IUa7FhQnMuGJPW
         DqbsW8JQzcmagCW0IIXJvsGgv7JU8y2weLZ4RcTpYaB31XhIR+Y7vuNavzjqU/QvDlxW
         E5Gp2LyIeIOAAct+1gAJ46wcyrvqZ/Z10lW1k=
MIME-Version: 1.0
In-Reply-To: <53ea87da0911140855u7993989aod746bcaf18ee4c31@mail.gmail.com>
References: <4AFD971C.3090204@csldevices.co.uk>
	 <4AFD9BAF.1010200@csldevices.co.uk>
	 <aday6mac5ai.fsf@roland-alpha.cisco.com> <4AFED614.1050109@gmail.com>
	 <53ea87da0911140855u7993989aod746bcaf18ee4c31@mail.gmail.com>
Date: Sat, 14 Nov 2009 12:19:13 -0600
Message-ID: <51f3faa70911141019y1248fb27k5f7edb3729f72375@mail.gmail.com>
Subject: Re: firmware loading interface
From: Robert Hancock <hancockrwd@gmail.com>
To: venu <vjosyula@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Philip Downer <phil@csldevices.co.uk>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 14, 2009 at 10:55 AM, venu <vjosyula@gmail.com> wrote:
>  who triggers this upgrade from userspace ? I understand it is a naivee /
> beginers questions but i hope somebody explains me how ?

The request_firmware interface probably isn't suitable for that..
using an ioctl or read/write-based interface, possibly on a separate
device node, would likely be the way to go..

>
> On Sat, Nov 14, 2009 at 9:38 PM, Robert Hancoctk <hancockrwd@gmail.cr tom>
> wrote:
>>
>> On 11/13/2009 06:35 PM, Roland Dreier wrote:
>>>
>>>  >  However our device will have flash to store the firmware in and,
>>> whilst
>>>  >  it looks as though it would be possible for us to use
>>> request_firmware
>>>  >  to provide occasional firmware upgrades from userspace, I can't find
>>> any
>>>  >  reference as to whether this is an accepted method for doing so.
>>> Could
>>>  >  someone please confirm for me whether or not it's a good idea to use
>>>  >  request_firmware for this, or perhaps point me at another standard
>>>  >  method for doing firmware updates from userspace?
>>>
>>> I think request_firmware() is fine for this... you could have a look at
>>> drivers/net/cxgb3 to see a device that writes new firmware to flash when
>>> it detects a version mismatch between driver and device.
>>
>> It depends on the consequences of a failed flash due to losing power,
>> crash, etc - if it has the potential to brick the device then I don't think
>> that should happen without the user triggering it explicitly..
