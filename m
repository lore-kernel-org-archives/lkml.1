Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbZARQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbZARQEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933732AbZARQEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:04:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:48311 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726AbZARQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:04:43 -0500
Message-ID: <154e089b0901180804k46e9411lcbc10f591871b14@mail.gmail.com>
Date: Sun, 18 Jan 2009 17:04:41 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Jaswinder Singh Rajput" <jaswinder@kernel.org>
Subject: Re: [PATCH 2/3] drivers/gpu/drm: fix sparse warnings: unexport symbols
Cc: dri-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1232294164.24415.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090118152725.4179.40835.stgit@vmbox.hanneseder.net>
	 <20090118152848.4179.85741.stgit@vmbox.hanneseder.net>
	 <1232294164.24415.3.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 4:56 PM, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
> On Sun, 2009-01-18 at 16:28 +0100, Hannes Eder wrote:
>> Fix this sparse warnings:
>>
>>   drivers/gpu/drm/drm_crtc_helper.c:137:6: warning: symbol 'drm_helper_probe_connector_modes' was not declared. Should it be static?
>>   drivers/gpu/drm/drm_modes.c:360:6: warning: symbol 'drm_mode_validate_clocks' was not declared. Should it be static?
>>
>> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>> ---
>>  drivers/gpu/drm/drm_crtc_helper.c |    6 +++---
>>  drivers/gpu/drm/drm_modes.c       |    7 +++----
>>  2 files changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
>> index d8a982b..a0b2601 100644
>> --- a/drivers/gpu/drm/drm_crtc_helper.c
>> +++ b/drivers/gpu/drm/drm_crtc_helper.c
>> @@ -134,8 +134,9 @@ void drm_helper_probe_single_connector_modes(struct drm_connector *connector,
>>  }
>>  EXPORT_SYMBOL(drm_helper_probe_single_connector_modes);
>>
>> -void drm_helper_probe_connector_modes(struct drm_device *dev, uint32_t maxX,
>> -                                   uint32_t maxY)
>> +static void drm_helper_probe_connector_modes(struct drm_device *dev,
>> +                                          uint32_t maxX,
>> +                                          uint32_t maxY)
>>  {
>>       struct drm_connector *connector;
>>
>> @@ -143,7 +144,6 @@ void drm_helper_probe_connector_modes(struct drm_device *dev, uint32_t maxX,
>>               drm_helper_probe_single_connector_modes(connector, maxX, maxY);
>>       }
>>  }
>> -EXPORT_SYMBOL(drm_helper_probe_connector_modes);
>>
>
> hmm, what you are trying to do ?
>
>>
>>  /**
>> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
>> index 7c36f16..c0cfe39 100644
>> --- a/drivers/gpu/drm/drm_modes.c
>> +++ b/drivers/gpu/drm/drm_modes.c
>> @@ -357,9 +357,9 @@ EXPORT_SYMBOL(drm_mode_validate_size);
>>   * sure each mode falls within a given range (defined by @min and @max
>>   * arrays) and sets @mode->status as needed.
>>   */
>> -void drm_mode_validate_clocks(struct drm_device *dev,
>> -                           struct list_head *mode_list,
>> -                           int *min, int *max, int n_ranges)
>> +static void drm_mode_validate_clocks(struct drm_device *dev,
>> +                                  struct list_head *mode_list,
>> +                                  int *min, int *max, int n_ranges)
>>  {
>>       struct drm_display_mode *mode;
>>       int i;
>> @@ -376,7 +376,6 @@ void drm_mode_validate_clocks(struct drm_device *dev,
>>                       mode->status = MODE_CLOCK_RANGE;
>>       }
>>  }
>> -EXPORT_SYMBOL(drm_mode_validate_clocks);
>
> ??

In both cases: a grep over the entire kernel tree shows that the
function is only used within the compilation unit it is defined,
therefore make it static and un-EXPORT it.

Hannes
