Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZLJOuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZLJOuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZLJOuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:50:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZLJOuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:50:04 -0500
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Jerry Leo <jerryleo860202@gmail.com>
Subject: Re: [PATCH]about eicon: array subscript is above array bounds
Date: Thu, 10 Dec 2009 15:49:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.37-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de, Armin Schindler <armin@melware.de>
References: <6304b52b0912092004t646569bdm2a6bbc9bb2440aba@mail.gmail.com>
In-Reply-To: <6304b52b0912092004t646569bdm2a6bbc9bb2440aba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912101549.52797.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX19QsS8OW7ekBTDVJIjWwHfSqsX4qHzCZg0km9k
 HCxoCCVOujLHvCihhgVRVHRdXPYpv1ERfaWjiCc8xJzXjsn5lZ
 5RQtUbWX7letJqT5xT9NP+5rYDjtcms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 10. Dezember 2009 05:04:35 Jerry Leo wrote:
> Hi, Karsten Keil,
> 
>         When i compile eicon,there have some waning look like this:

This looks wrong, but I do not know this part so well.

Armin ?

> 
>            CC [M]  drivers/isdn/hardware/eicon/message.o
> drivers/isdn/hardware/eicon/message.c: In function ‘add_b23’:
> drivers/isdn/hardware/eicon/message.c:8426: warning: array subscript
> is above array bounds
> drivers/isdn/hardware/eicon/message.c:8427: warning: array subscript
> is above array bounds
> drivers/isdn/hardware/eicon/message.c:8434: warning: array subscript
> is above array bounds
> drivers/isdn/hardware/eicon/message.c:8435: warning: array subscript
> is above array bounds
> drivers/isdn/hardware/eicon/message.c:8436: warning: array subscript
> is above array bounds
> drivers/isdn/hardware/eicon/message.c:8447: warning: array subscript
> is above array bounds
> 
> I think the array is short then be used,because the array's max length
> is 20, then it will use long than this, the code is in
> "drivers/isdn/hardware/eicon/divacapi.h" 1360L, 50994C  :
> 
> 
> #define T30_MAX_STATION_ID_LENGTH       20
> #define T30_MAX_SUBADDRESS_LENGTH       20
> #define T30_MAX_PASSWORD_LENGTH         20
> 
> typedef struct t30_info_s T30_INFO;
> struct t30_info_s {
>   byte          code;
>   byte          rate_div_2400;
>   byte          resolution;
>   byte          data_format;
>   byte          pages_low;
>   byte          pages_high;
>   byte          operating_mode;
>   byte          control_bits_low;
>   byte          control_bits_high;
>   byte          feature_bits_low;
>   byte          feature_bits_high;
>   byte          recording_properties;
>   byte          universal_6;
>   byte          universal_7;
>   byte          station_id_len;
>   byte          head_line_len;
>   byte          station_id[T30_MAX_STATION_ID_LENGTH];
> /* byte          head_line[];      */
> /* byte          sub_sep_length;   */
> /* byte          sub_sep_field[];  */
> /* byte          pwd_length;       */
> /* byte          pwd_field[];      */
> /* byte          nsf_info_length;   */
> /* byte          nsf_info_field[];  */
> };
> 
> "drivers/isdn/hardware/eicon/message.c" 15071L, 487328C
> 
>         if (pos != 0)
>         {
>           if (CAPI_MAX_DATE_TIME_LENGTH + 2 +
> b3_config_parms[3].length > CAPI_MAX_HEAD_LINE_SPACE)
>             pos = 0;
>           else
>           {
>             ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
>             ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
>             len = (byte)b3_config_parms[2].length;
>             if (len > 20)
>               len = 20;
>             if (CAPI_MAX_DATE_TIME_LENGTH + 2 + len + 2 +
> b3_config_parms[3].length <= CAPI_MAX_HEAD_LINE_SPACE)
>             {
>               for (i = 0; i < len; i++)
>                 ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte
>   *)b3_config_parms[2].info)[1+i];
>               ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
>               ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
>             }
>           }
>         }
> 
> 
> 
> can this patch commit?
> 

Wrong fileorder, this is a reverse patch.
But I  think the code should be fixed.

> 
> diff -up linux-2.6/drivers/isdn/hardware/eicon/divacapi.h
> linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig
> --- linux-2.6/drivers/isdn/hardware/eicon/divacapi.h	2009-12-10
> 12:02:46.000000000 +0800
> +++ linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig	2009-12-10
> 11:04:07.000000000 +0800
> @@ -445,7 +445,7 @@ struct _DIVA_CAPI_ADAPTER {
>  #define CAPI_MAX_HEAD_LINE_SPACE        89
>  #define CAPI_MAX_DATE_TIME_LENGTH       18
> 
> -#define T30_MAX_STATION_ID_LENGTH       30
> +#define T30_MAX_STATION_ID_LENGTH       20
>  #define T30_MAX_SUBADDRESS_LENGTH       20
>  #define T30_MAX_PASSWORD_LENGTH         20
> 
