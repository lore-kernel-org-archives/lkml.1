Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbYJ3TJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbYJ3TJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYJ3TIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:08:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45519 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYJ3TIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:08:54 -0400
Date: Thu, 30 Oct 2008 20:10:28 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: clean up adapter.h a bit
Message-ID: <20081030191028.GB22185@elf.ucw.cz>
References: <1225376079-9592-1-git-send-email-penberg@cs.helsinki.fi> <1225376079-9592-2-git-send-email-penberg@cs.helsinki.fi> <1225376079-9592-3-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225376079-9592-3-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 16:14:37, Pekka Enberg wrote:
> This patch cleans up adapter.h a bit in preparation for merging struct
> wb35_adapter to struct wbsoft_priv.

Acked-by: Pavel Machek <pavel@suse.cz>

> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  drivers/staging/winbond/adapter.h |   17 +++--------------
>  drivers/staging/winbond/common.h  |    3 ---
>  drivers/staging/winbond/mds_s.h   |    1 -
>  drivers/staging/winbond/wbhal.c   |   10 +++++-----
>  4 files changed, 8 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/staging/winbond/adapter.h b/drivers/staging/winbond/adapter.h
> index 11df483..239cc3a 100644
> --- a/drivers/staging/winbond/adapter.h
> +++ b/drivers/staging/winbond/adapter.h
> @@ -7,20 +7,9 @@
>  #include "mto.h"
>  #include "wbhal_s.h"
>  
> -#define OS_SET_SHUTDOWN( _A )		_A->shutdown=1
> -#define OS_SET_RESUME( _A )		_A->shutdown=0
> -#define OS_STOP( _A )	WBLINUX_stop( _A )
> +#define WBLINUX_PACKET_ARRAY_SIZE (ETHERNET_TX_DESCRIPTORS*4)
>  
> -#define OS_CURRENT_RX_BYTE( _A )		_A->RxByteCount
> -#define OS_CURRENT_TX_BYTE( _A )		_A->TxByteCount
> -#define OS_EVENT_INDICATE( _A, _B, _F )
> -#define OS_PMKID_STATUS_EVENT( _A )
> -#define OS_RECEIVE_802_1X_PACKET_INDICATE( _A, _D )	EAP_ReceivePacket( _A, _D )
> -#define OS_SEND_RESULT( _A, _ID, _R )
> -
> -#define WBLINUX_PACKET_ARRAY_SIZE	(ETHERNET_TX_DESCRIPTORS*4)
> -
> -#define MAX_ANSI_STRING		40
> +#define WB_MAX_LINK_NAME_LEN 40
>  
>  struct wb35_adapter {
>  	u32 adapterIndex;	// 20060703.4 Add for using padapterContext global adapter point
> @@ -49,7 +38,7 @@ struct wb35_adapter {
>  	s32 netif_state_stop;	// 1: stop  0: normal
>  	struct iw_statistics iw_stats;
>  
> -	u8 LinkName[MAX_ANSI_STRING];
> +	u8 LinkName[WB_MAX_LINK_NAME_LEN];
>  };
>  
>  #endif
> diff --git a/drivers/staging/winbond/common.h b/drivers/staging/winbond/common.h
> index 2badc29..c4d9604 100644
> --- a/drivers/staging/winbond/common.h
> +++ b/drivers/staging/winbond/common.h
> @@ -23,8 +23,5 @@
>  #define WBDEBUG( _M )	0
>  #endif
>  
> -#define OS_EVENT_INDICATE( _A, _B, _F )
> -#define OS_PMKID_STATUS_EVENT( _A )
> -
>  #endif // COMMON_DEF
>  
> diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
> index 02b1182..29f1568 100644
> --- a/drivers/staging/winbond/mds_s.h
> +++ b/drivers/staging/winbond/mds_s.h
> @@ -14,7 +14,6 @@
>  #define MAX_USB_TX_BUFFER_NUMBER	4		// Virtual pre-buffer number of MAX_USB_TX_BUFFER
>  #define MAX_USB_TX_BUFFER			4096	// IS89C35 ability 4n alignment is required for hardware
>  
> -#define MDS_EVENT_INDICATE( _A, _B, _F )	OS_EVENT_INDICATE( _A, _B, _F )
>  #define AUTH_REQUEST_PAIRWISE_ERROR			0		// _F flag setting
>  #define AUTH_REQUEST_GROUP_ERROR			1		// _F flag setting
>  
> diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
> index 3b7e90b..a7d25a6 100644
> --- a/drivers/staging/winbond/wbhal.c
> +++ b/drivers/staging/winbond/wbhal.c
> @@ -223,8 +223,8 @@ static void hal_led_control(unsigned long data)
>  				else
>  				{
>  					// Is transmitting/receiving ??
> -					if( (OS_CURRENT_RX_BYTE( adapter ) != pHwData->RxByteCountLast ) ||
> -						(OS_CURRENT_TX_BYTE( adapter ) != pHwData->TxByteCountLast ) )
> +					if( (adapter->RxByteCount != pHwData->RxByteCountLast ) ||
> +						(adapter->TxByteCount != pHwData->TxByteCountLast ) )
>  					{
>  						if( (reg->U1BC_LEDConfigure & 0x3000) != 0x3000 )
>  						{
> @@ -233,8 +233,8 @@ static void hal_led_control(unsigned long data)
>  						}
>  
>  						// Update variable
> -						pHwData->RxByteCountLast = OS_CURRENT_RX_BYTE( adapter );
> -						pHwData->TxByteCountLast = OS_CURRENT_TX_BYTE( adapter );
> +						pHwData->RxByteCountLast = adapter->RxByteCount;
> +						pHwData->TxByteCountLast = adapter->TxByteCount;
>  						TimeInterval = 200;
>  					}
>  					else
> @@ -849,7 +849,7 @@ void hal_surprise_remove(struct wb35_adapter *adapter)
>  		#ifdef _PE_STATE_DUMP_
>  		WBDEBUG(("Calling hal_surprise_remove\n"));
>  		#endif
> -		OS_STOP( adapter );
> +		WBLINUX_stop( adapter );
>  	}
>  }
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
