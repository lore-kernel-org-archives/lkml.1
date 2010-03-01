Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0CAXVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:21:17 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:19617 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0CAXVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:21:16 -0500
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 18:21:16 EST
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371Pab9bhzz1202hzzz2fh2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B8C485A.8000409@am.sony.com>
Date: Mon, 1 Mar 2010 15:06:02 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH 03/11] drivers: net: optimize hex2bin()
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>  <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2010 23:06:03.0390 (UTC) FILETIME=[C40B81E0:01CAB993]
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Sorry for the delay, I was working away from my test equipment
and wanted to test this change before commenting.

On 02/22/2010 10:09 AM, Andy Shevchenko wrote:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> 
> Optimize hex2bin() function used in ps3_gelic_wireless.c. It requires to have
> hex_to_bin() implementation introduced by starter patch in series.
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
>  drivers/net/ps3_gelic_wireless.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> --- a/drivers/net/ps3_gelic_wireless.c
> +++ b/drivers/net/ps3_gelic_wireless.c
> @@ -1394,23 +1394,19 @@ static int gelic_wl_get_mode(struct net_device *netdev,
>  static int hex2bin(u8 *str, u8 *bin, unsigned int len)
>  {
>  	unsigned int i;
> -	static unsigned char *hex = "0123456789ABCDEF";
> -	unsigned char *p, *q;
> -	u8 tmp;
>  
>  	if (len != WPA_PSK_LEN * 2)
>  		return -EINVAL;
>  
>  	for (i = 0; i < WPA_PSK_LEN * 2; i += 2) {
> -		p = strchr(hex, toupper(str[i]));
> -		q = strchr(hex, toupper(str[i + 1]));
> -		if (!p || !q) {
> +		int h = hex_to_bin(str[i]);
> +		int l = hex_to_bin(str[i+1]);
> +		if ((h == -1) || (l == -1)) {

We should have a blank line between the two variable declarations
and the if statement here.

Please make an updated patch, otherwise this patch looks OK,
and seems to work correctly on PS3.

-Geoff


