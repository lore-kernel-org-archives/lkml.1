Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870Ab0A1G54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0A1G54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656Ab0A1G54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:57:56 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:48494 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0A1G5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:57:55 -0500
Message-ID: <4B613586.306@xenontk.org>
Date: Thu, 28 Jan 2010 12:28:14 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: yakui.zhao@intel.com, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, stable@kernel.org
Subject: Re: [PATCH] Disable SR when more than one pipe is enabled
References: <4B60080E.2000508@xenontk.org>	<1264585748-16929-1-BlackWidow-davidjon@xenontk.org> <20100127085103.317e5ad8@jbarnes-piketon>
In-Reply-To: <20100127085103.317e5ad8@jbarnes-piketon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 10:21 PM, Jesse Barnes wrote:
> On Wed, 27 Jan 2010 15:19:08 +0530
> David John <davidjon@xenontk.org> wrote:
> 
>> Self Refresh should be disabled on dual plane configs.
>> Otherwise, as the SR watermark is not calculated for
>> such configs, switching to non VGA mode causes FIFO
>> underrun and display flicker.
>>
>> This fixes Korg Bug # 14897.
>>
>> Signed-off-by: David John <davidjon@xenontk.org>
>>
>> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
>> index 45da78e..46d7c0c 100644
>> --- a/drivers/gpu/drm/i915/intel_display.c
>> +++ b/drivers/gpu/drm/i915/intel_display.c
>> @@ -2519,6 +2519,10 @@ static void g4x_update_wm(struct drm_device *dev,  int planea_clock,
>>  		sr_entries = roundup(sr_entries / cacheline_size, 1);
>>  		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
>>  		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
>> +	} else {
>> +		/* Turn off self refresh if both pipes are enabled */
>> +		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
>> +					& ~FW_BLC_SELF_EN);
>>  	}
>>  
>>  	DRM_DEBUG("Setting FIFO watermarks - A: %d, B: %d, SR %d\n",
>> @@ -2562,6 +2566,10 @@ static void i965_update_wm(struct drm_device *dev, int planea_clock,
>>  			srwm = 1;
>>  		srwm &= 0x3f;
>>  		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
>> +	} else {
>> +		/* Turn off self refresh if both pipes are enabled */
>> +		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
>> +					& ~FW_BLC_SELF_EN);
>>  	}
>>  
>>  	DRM_DEBUG_KMS("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n",
>> @@ -2630,6 +2638,10 @@ static void i9xx_update_wm(struct drm_device *dev, int planea_clock,
>>  		if (srwm < 0)
>>  			srwm = 1;
>>  		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN | (srwm & 0x3f));
>> +	} else {
>> +		/* Turn off self refresh if both pipes are enabled */
>> +		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
>> +					& ~FW_BLC_SELF_EN);
>>  	}
>>  
>>  	DRM_DEBUG_KMS("Setting FIFO watermarks - A: %d, B: %d, C: %d, SR %d\n",
>>
> 
> Great!  Looks like the docs were a bit misleading here.  Disabling
> self-refresh for dual plane configs is the safest thing to do.
> 
> Eric, please apply asap.  Should probably go to stable as well.
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 

[ Adding Eric and stable (for 2.6.32 series) to CC]

Regards,
David.
