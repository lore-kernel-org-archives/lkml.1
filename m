Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab0CDSD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:03:57 -0500
Received: from xenotime.net ([72.52.64.118]:39067 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750719Ab0CDSDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:03:55 -0500
Date: Thu, 4 Mar 2010 10:03:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>, Haiyang Zhang <haiyangz@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: Re: [PATCH 1/1] Stage: hv: Corrected all header comments to follow
 kernel-doc format
Message-Id: <20100304100352.d7bd75fb.rdunlap@xenotime.net>
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56217DBFDF9@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
	<8AFC7968D54FB448A30D8F38F259C56217DBFDF9@TK5EX14MBXC116.redmond.corp.microsoft.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 17:48:18 +0000 Hank Janssen wrote:

> 
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Removed kerneldoc /** from functions that should not have them.
> Added proper kerneldoc headers to functions that should have them.

Hi,

Most of the patch looks good.  I found a few nits to pick.
Please see below.

> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> ---
>  drivers/staging/hv/Channel.c     |   49 ++++++++++++++-----------
>  drivers/staging/hv/ChannelMgmt.c |   33 +++++++++--------
>  drivers/staging/hv/Connection.c  |   14 ++++----
>  drivers/staging/hv/Hv.c          |   18 +++++-----
>  drivers/staging/hv/NetVsc.c      |    8 ++--
>  drivers/staging/hv/StorVsc.c     |   10 +++---
>  drivers/staging/hv/TODO          |    1 -
>  drivers/staging/hv/Vmbus.c       |   26 +++++++-------
>  drivers/staging/hv/VmbusApi.h    |   19 ++++++++++
>  drivers/staging/hv/blkvsc_drv.c  |    6 ++--
>  drivers/staging/hv/netvsc_drv.c  |    4 +-
>  drivers/staging/hv/osd.c         |   70 +++++++++++++++++++++++++++++++++++
>  drivers/staging/hv/storvsc_drv.c |   14 ++++----
>  drivers/staging/hv/vmbus_drv.c   |   74 +++++++++++++++++++++++++------------
>  14 files changed, 233 insertions(+), 113 deletions(-)



diff --git a/drivers/staging/hv/VmbusApi.h b/drivers/staging/hv/VmbusApi.h index d089bb1..2e3a3b8 100644
> --- a/drivers/staging/hv/VmbusApi.h
> +++ b/drivers/staging/hv/VmbusApi.h
> @@ -84,6 +84,25 @@ struct hv_device_info {
>         struct hv_dev_port_info Outbound;
>  };
> 
> +/**
> + * struct vmbus_channel_interface - Contains member functions for vmbus channel
> + * @Open:      Open the channel
> + * @Close:     Close the channel
> + * @SendPacket:        Send a packet over the channel
> + * @SendPacketPageBuffer:      Send a single page buffer over the channel
> + * @SendPacketMultiPageBuffer: Send a multiple page buffers
> + * @RecvPacket:        Receive packet
> + * @RecvPacketRaw:     Receive Raw packet
> + * @EstablishGpadl:    Set up GPADL for ringbuffer
> + * @TeardownGpadl:     Teardown GPADL for ringbuffer
> + * @GetInfo:   Get info about the channel
> + *
> + * This structure contains function pointer to control vmbus channel
> + * behavior.
> + * None of these functions is externally callable, but they are used
> +for normal

There appears to be some unwanted line breaking ^here^.

> + * vmbus channel internal behavior.
> + * Only used by Hyper-V drivers.
> + */
>  struct vmbus_channel_interface {
>         int (*Open)(struct hv_device *Device, u32 SendBufferSize,
>                     u32 RecvRingBufferSize, void *UserData, u32 UserDataLen, diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c index abeac12..c90a6aa 100644


and why are those 2 lines above joined/merged?
I suspect that it will be a bit difficult for Greg to apply this patch.


diff --git a/drivers/staging/hv/osd.c b/drivers/staging/hv/osd.c index 3a4793a..5afa94e 100644
> --- a/drivers/staging/hv/osd.c
> +++ b/drivers/staging/hv/osd.c
> @@ -77,6 +86,14 @@ void *osd_PageAlloc(unsigned int count)  }  EXPORT_SYMBOL_GPL(osd_PageAlloc);
> 
> +/**
> + * osd_PageFree() - Free pages
> + * @page:       Pointer to the first page to be freed
> + * @count:      Total number of Kernel pages you free
> + *
> + * Frees the pages allocated by osd_PageAlloc()
> + * Mainly used by Hyper-V drivers.
> + */
>  void osd_PageFree(void *page, unsigned int count)  {
>         free_pages((unsigned long)page, get_order(count * PAGE_SIZE)); @@ -85,6 +102,17 @@ void osd_PageFree(void *page, unsigned int count)  }  EXPORT_SYMBOL_GPL(osd_PageFree);
> 
> +/**
> + * osd_WaitEventCreate() - Create the event queue
> + *
> + * Allocates memory for a &struct osd_waitevent. And than calls

aha.  Correct struct reference, using '&'.  :)

> + * init_waitqueue_head to set up the wait queue for the event.
> + * This structure is usually part of a another structure that contains
> + * the actual Hyper-V device driver structure.
> + *
> + * Returns pointer to &struct osd_waitevent
> + * Mainly used by Hyper-V drivers.
> + */
>  struct osd_waitevent *osd_WaitEventCreate(void)  {
>         struct osd_waitevent *wait = kmalloc(sizeof(struct osd_waitevent), @@ -98,6 +126,19 @@ struct osd_waitevent *osd_WaitEventCreate(void)  }  EXPORT_SYMBOL_GPL(osd_WaitEventCreate);
> 
> +
> +/**
> + * osd_WaitEventSet() - Wake up the process
> + * @waitEvent: Structure to event to be woken up
> + *
> + * @waitevent is of type @struct osd_waitevent

Use '&' here also.

> + *
> + * Wake up the sleeping process so it can do some work.
> + * And set condition indicator in struct osd_waitevent to indicate
> + * the process is in a woken state.
> + *
> + * Only used by Network and Storage Hyper-V drivers.
> + */
>  void osd_WaitEventSet(struct osd_waitevent *waitEvent)  {
>         waitEvent->condition = 1;
> @@ -105,6 +146,20 @@ void osd_WaitEventSet(struct osd_waitevent *waitEvent)  }  EXPORT_SYMBOL_GPL(osd_WaitEventSet);
> 
> +/**
> + * osd_WaitEventWait() - Wait for event till condition is true
> + * @waitEvent: Structure to event to be put to sleep
> + *
> + * @waitevent is of type @struct osd_waitevent

Use '&' here also.

> + *
> + * Set up the process to sleep until waitEvent->condition get true.
> + * And set condition indicator in struct osd_waitevent to indicate
> + * the process is in a sleeping state.
> + *
> + * Returns the status of 'wait_event_interruptible()' system call
> + *
> + * Mainly used by Hyper-V drivers.
> + */
>  int osd_WaitEventWait(struct osd_waitevent *waitEvent)  {
>         int ret = 0;
> @@ -116,6 +171,21 @@ int osd_WaitEventWait(struct osd_waitevent *waitEvent)  }  EXPORT_SYMBOL_GPL(osd_WaitEventWait);
> 
> +/**
> + * osd_WaitEventWaitEx() - Wait for event or timeout for process wakeup
> + * @waitEvent: Structure to event to be put to sleep
> + * @TimeoutInMs:       Total number of Milliseconds to wait before waking up
> + *
> + * @waitevent is of type @struct osd_waitevent

Use '&' here also.

> + * Set up the process to sleep until @waitEvent->condition get true or
> + * @TimeoutInMs (Time out in Milliseconds) has been reached.
> + * And set condition indicator in struct osd_waitevent to indicate
> + * the process is in a sleeping state.
> + *
> + * Returns the status of 'wait_event_interruptible_timeout()' system
> +call
> + *
> + * Mainly used by Hyper-V drivers.
> + */
>  int osd_WaitEventWaitEx(struct osd_waitevent *waitEvent, u32 TimeoutInMs)  {
>         int ret = 0;



---
~Randy
