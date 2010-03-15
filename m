Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935837Ab0COIsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:48:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:12315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935629Ab0COIr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,641,1262592000"; 
   d="scan'208";a="780826730"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jdike@c2.user-mode-linux.org" <jdike@c2.user-mode-linux.org>
Date: Mon, 15 Mar 2010 16:46:50 +0800
Subject: RE: [PATCH v1 2/3] Provides multiple submits and asynchronous
	notifications.
Thread-Topic: [PATCH v1 2/3] Provides multiple submits and asynchronous
	notifications.
Thread-Index: Acq96Q+uFqUQVn/6TNquqA2VL12ofwGMBpvA
Message-ID: <97F6D3BD476C464182C1B7BABF0B0AF5C164CEED@shzsmsx502.ccr.corp.intel.com>
References: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com>
 <1267868318-19268-2-git-send-email-xiaohui.xin@intel.com>
 <1267868318-19268-3-git-send-email-xiaohui.xin@intel.com>
 <20100307111816.GC20004@redhat.com>
In-Reply-To: <20100307111816.GC20004@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/* The structure to notify the virtqueue for async socket */
>> +struct vhost_notifier {
>> +	struct list_head list;
> >+	struct vhost_virtqueue *vq;
> >+	int head;
> >+	int size;
> >+	int log;
> >+	void *ctrl;
> >+	void (*dtor)(struct vhost_notifier *);
> >+};
> >+

>So IMO, this is not the best interface between vhost
>and your driver, exposing them to each other unnecessarily.
>
>If you think about it, your driver should not care about this structure.
>It could get e.g. a kiocb (sendmsg already gets one), and call ki_dtor
>on completion.  vhost could save it's state in ki_user_data.  If your
>driver needs to add more data to do more tracking, I think it can put
>skb pointer in the private pointer.

Then if I remove the struct vhost_notifier, and just use struct kiocb, but don't use the one got from sendmsg or recvmsg, but allocated within the page_info structure, and don't implement any aio logic related to it, is that ok?

Sorry, I made a patch, but don't know how to reply mail with a good formatted patch here....

Thanks
Xiaohui
