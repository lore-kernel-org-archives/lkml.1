Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYJSWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYJSWNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYJSWNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:13:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:9280 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYJSWMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dk+WYVbYj55UIT1pt5M1Z5jpGjq83an1E3VImjaeBOAgsQil5q1eEHAzD9sZmF2XyX
         oh7tQ+/+csWFEiXu7a7kLzpuUQ/VuEgqUq9xYZgvpb8bxXDRMhFQnpEdYIIfbdPJZPrb
         SIVusJRh4o8uM2yPCaoFbdOjyRAEsZ9kKtFmI=
Message-ID: <1ba2fa240810191512i4c6ce748kd13d1671cc2a2ff6@mail.gmail.com>
Date: Mon, 20 Oct 2008 00:12:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andy Lutomirski" <luto@myrealbox.com>
Subject: Re: iwlagn: associating with AP causes kernel hiccup
Cc: richard@scherping.de, "Frederik Himpe" <fhimpe@telenet.be>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48FB4FBE.2060909@myrealbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>
	 <gd9v3f$3ft$1@ger.gmane.org> <gd9vpo$5ql$1@ger.gmane.org>
	 <48F8AEF1.5030603@scherping.de>
	 <1ba2fa240810171302h7dcc92acr18c060425c4a93d@mail.gmail.com>
	 <48FA0C27.8010301@scherping.de> <48FB4FBE.2060909@myrealbox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 5:18 PM, Andy Lutomirski <luto@myrealbox.com> wrote:
> Richard Scherping wrote:
>>
>> Tomas Winkler schrieb:
>>>
>>> On Fri, Oct 17, 2008 at 5:27 PM, Richard Scherping
>>> <richard-YwAN3MSemFZ6lmGzAMPh1A@public.gmane.org> wrote:
>>>>>>>>
>>>>>>>> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few
>>>>>>>> seconds. During that time, all sound stops playing and keyboard and
>>>>>>>> mouse input is impossible.
>>>>>>
>>>>>> I'm using Mandriva 2009.0 x86_64 with wpa_supplicant and Mandriva's
>>>>>> wireless network configuration tool (drakroam).
>>>>>>
>>>>>> Actually I just found out that running # ifconfig wlan0 down
>>>>>> is enough to trigger the sound and mouse hanging for a few seconds.
>>>>>
>>>>> And shortly after I wrote that, while associating while getting an IP
>>>>> with dhclient when associating with a WPA encrypted AP, I got this
>>>>> backtrace in my logs:
>>>>> [...]
>>>>
>>>> I have a similar problem here. No crash up to now, but the very same
>>>> "hang" for a few seconds on "ifconfig wlan0 down". Interestingly this does
>>>> only happen after a normal boot - once I did a suspend and resume (S3),
>>>> there is no hang anymore.
>>>>
>>>> Hardware: Thinkpad T61p with Intel 4965 agn
>>>> Software: Debian Lenny x86_64 with vanilla 2.6.27 kernel
>>>>
>>> Driver in 2.6.27 is not stable, please try to reproduce this in
>>> current wireless-testing.git.
>>
>> I do not have the time to compile and test wireless-testing ATM, sorry.
>>
>> In fact I am annoyed by the fact that iwlagn is "known to be unstable" in
>> a stable kernel release and that this even seems to be a totally normal
>> thing...

>
> Amen.
Stable doesn't mean all components are stable, citation  from Linus blog:
"It doesn't have to be perfect (and obviously no release ever is), but
it needs to be in reasonable shape"

The fact is that some critical patches were rejected as not
regressions in rc cycle and probably need to be pushed to the stable
version now or distribution will merge them.
We gave more priority for testing 32 bit version so it is more stable
then 64 bit which got much less in house testing and we've missed many
issues there. The driver doesn't get full exposure till it's get to
the public in stable version therefore  no bugs are opened in the rc
cycle so also are not fixed in the stable version. and unfortunately
there is no much system testing at all for what get's into merging
window.
Second the whole mac80211 stack didn't address fully MQ rewrite so
it's a bit shaky as well and this will be fact also in 2.6.28.

This driver has been available and more-or-less working for ages.
> What kernel am I supposed to run if I just want a stable system? Haven't
> found one yet, other than distro kernels...
>
> In any case, I've seen these complete system hiccups with iwl4965 and iwlagn
> since at least 2.6.25 and through quite a few wireless-testing versions.  I
> bet that this, along with things like it, is the culprit:

Haven't seen you've filled bug for it.

>
> In many, many functions:
>  spin_lock_irqsave(&priv->lock, flags);
>  ...
>  ret = iwl_grab_nic_access(priv);
>
> In iwl-io.h (2.6.26.something):

This code is here from version 2.6.18 at least was just moved around.

> static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
> {
>        ...
>        ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
>                           CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
>                           (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
>                            CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
>        ...
> }
>
> static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
>                                u32 bits, u32 mask, int timeout)
> {
>        int i = 0;
>
>        do {
>                if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
>                        return i;
>                mdelay(10);
>                i += 10;
>        } while (i < timeout);
>
>        return -ETIMEDOUT;
> }
>
> Polling the hardware waiting for firmware to do something *with IRQs
> disabled*?  I'd really rather the drivers on my system didn't do this.
>
> I'd attempt to fix this myself, but I have no clue what the locking rules
> are supposed to be.

Locking need to be really revised but till now I didn't see show
stoppers issues so it didn't get priority

> Would I be out of line for wishing the iwlwifi developers
Patches are always welcome

would fix
> longstanding issues (latency and maybe horkage after resume, although the
> latter seems much improved lately) before adding fancy new things?

There are also problem in mac80211 it self and we did as well some
work to improve it a bit.
Tomas
