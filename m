Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYKNS5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYKNS5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYKNS5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:57:41 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:39900 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbYKNS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ELLYRjQhBtd2BVSt9G30ZbhFkKVgeNpsqj2qGR9bbbNxM8ftHW5trcLid5S3/p6KKX
         f2G12pt6zq3A75XNaDMWFtWgc++yGnbxb0rXJERyVu/WUWbfKJDpUVgAqUVuQ/6fwrfx
         NETAejzG9nGGS2209Nlpkvbcf/gdAx61SZX4g=
Message-ID: <491DCA12.3000304@gmail.com>
Date: Fri, 14 Nov 2008 20:57:22 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
References: <491506DB.1070000@gmail.com> <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com> <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com> <491B17B3.204@gmail.com> <20081114034730.GA9482@hash.localnet>
In-Reply-To: <20081114034730.GA9482@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland wrote:
> On Wed, Nov 12, 2008 at 07:51:47PM +0200, Maxim Levitsky wrote:
>>>> Why it doesn't accept new mac?, can this be fixed?
>> Any update on mac changer status?
> 
> As a first stab, can you try this patch?  This sets the address on
> add_interface and clears it on remove_interface, instead of only doing
> it at probe time.  I only compile-tested it.
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 5ef8cc4..6c56893 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2765,6 +2765,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
>  	/* Set to a reasonable value. Note that this will
>  	 * be set to mac80211's value at ath5k_config(). */
>  	sc->bintval = 1000;
> +	ath5k_hw_set_lladdr(sc->ah, conf->mac_addr);
>  
>  	ret = 0;
>  end:
> @@ -2777,11 +2778,13 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
>  			struct ieee80211_if_init_conf *conf)
>  {
>  	struct ath5k_softc *sc = hw->priv;
> +	u8 mac[ETH_ALEN] = {};
>  
>  	mutex_lock(&sc->lock);
>  	if (sc->vif != conf->vif)
>  		goto end;
>  
> +	ath5k_hw_set_lladdr(sc->ah, mac);
>  	sc->vif = NULL;
>  end:
>  	mutex_unlock(&sc->lock);
> 

Works almost perfectly,


when I load the module, then run macchanger, and then ifconfig wlan0 up
then it works, if I do an ifconfig up once, then ifdowning the interface, it doesn't.

my iwl3945 allows me to

ifconfig wlan0 down
macchanger ....
ifconfig wlan0 up


The noise floor calibration issue bites me again and gain.
When it shows up, usually card continues to work, but at next assotiation stops working.
Maybe this is unrelated, don't know.
Reboot doesn't help, only a cold reboot/suspend to ram helps.
(Module reload doesn't help too).



Transfer speeds are unusually low:
Currently I compile kernel on main laptop, and copy files over nfs to aspire one.
Copying takes ages, and transfer speeds are at 200 Kbytes/s.
(AP isn't involved in direct transfers between stations, right?)

Both notebooks are in same room.


Also noticed, that continued transfer of large volumes (like the above) triggers
noise calibration time-outs, and when it does transfer speeds drop to 50Kbytes/s
Next assotiation usually fails, and only on/off cycle fixes this.

Best regards, and big thanks for help,
	Maxim Levitsky

















