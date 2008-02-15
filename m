Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbYBOWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbYBOWyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932502AbYBOWit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:44635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbYBOWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sh+aSoqgUY21fUujsSTbAtXv1QG+igiVvhRToinioCG8uFWtz8FNRj/8Wj4YKjjaIikHyjawTIegN6q538AdDfVB7SWsd9jZ6FyF2d9UYVqRgURlr3eHGOhRv1mA87wzpcCotegIOYxJbPD0clqD7qHXxMeO3vYT4qTyx+b4YEQ=
Message-ID: <47B61473.7060206@gmail.com>
Date: Fri, 15 Feb 2008 23:38:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 2/3] WDEV, ath5k, don't return int from bool function
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>	 <1203109133-32217-2-git-send-email-jirislaby@gmail.com> <43e72e890802151408g35fa2e49r5eb8557e4a5bbce4@mail.gmail.com>
In-Reply-To: <43e72e890802151408g35fa2e49r5eb8557e4a5bbce4@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2008 11:08 PM, Luis R. Rodriguez wrote:
> On Fri, Feb 15, 2008 at 3:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>>  -static bool
>>  +static int
>>   ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
>>         unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
>>         unsigned int tx_rate3, u_int tx_tries3)
>>  @@ -3773,10 +3773,10 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
>>
>>   #undef _XTX_TRIES
>>
>>  -               return true;
>>  +               return 1;
>>         }
>>
>>  -       return false;
>>  +       return 0;
>>   }
> 
> Shouldn't we then treat 0 as OK?

Sorry, I don't understand you. There is return -EINVAL in the function above 
this too and we need to cope with another two states but the error: it is 
supported/it isn't. You mean to consider 0 as supported, -ENODEV/-EOPNOTSUPP as 
unsupported and the rest as error?
