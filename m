Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbYCUUHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbYCUUHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761464AbYCUUHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:07:09 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:26305 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761455AbYCUUHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nhU3l81JbbhytjFrSy+djlcynMCEpr5+O5GOXeYHAb4PjzKB28TEIP9zIweqcgHrCBfNb5cXYbqiyIE1jMX3aHmfXIc3aSiuNTqCMDf6hxX35Uwei09rH0bWs6WtdQK5ShcKmVQJm5B0ghYQqjoh1S31VBMW5+vBPf3J3b3oGk0=
Date: Fri, 21 Mar 2008 16:07:01 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Input: add flags bitfield
Message-ID: <20080321160048.ZZRA012@mailhub.coreip.homeip.net>
References: <1205698451-1640-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205698451-1640-1-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

On Sun, Mar 16, 2008 at 05:14:11PM -0300, Henrique de Moraes Holschuh wrote:
> Add a flags bitfield to the input_dev structure, which can be used for
> internal coordination among kernel input devices and input handlers without
> the need to use ever-expanding blacklists on the input handlers.
> 
> Add initial flag bits which allows an input driver to request that joystick
> emulation (joydev) or mouse emulation (mousedev) not be attached to an
> input device.
> 
> This will be used by accelerometer drivers exporting a raw interface which
> is not to be used as a joystick device (not to confuse this with the usual
> fuzzed joystick interface these drivers export for enhanced Neverball
> productivity), for example.
> 

I'd rather not apply this patch because it pushes kowledge of existing
input interfaces into device drivers. What we could do instead is add
a 'type' field to the input device structure and then input interfaces
(evdev/mousedev, etc) could have an option of matching either by device
type or by device capabilities or both. Your raw devices could have type
of accelerometer and joydev would bind to devices with type "joystick"
or "unknown" + certain capabilities. Will this work?

-- 
Dmitry
