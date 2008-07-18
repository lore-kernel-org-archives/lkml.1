Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYGRLjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYGRLjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYGRLjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:39:00 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34888 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbYGRLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:39:00 -0400
Message-ID: <488080B1.8010207@s5r6.in-berlin.de>
Date: Fri, 18 Jul 2008 13:38:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Subject: Re: PATCH] firewire: add padding to some struct
References: <416379761.08031@ustc.edu.cn>
In-Reply-To: <416379761.08031@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang wrote:
> If p is a pointer to struct fw_cdev_event_response), p->data will point to the
> padding data rather than the right place, it will cause problem under some
> platforms. For example, in the function handle_device_event of libraw1394(ported
> to juju stack):
> .....
> case FW_CDEV_EVENT_RESPONSE:
>     rc = u64_to_ptr(u->response.closure);
>     if (rc->data != NULL)
> 	memcpy(rc->data, u->response.data, rc->length);//here it will lost the last four
> bytes
>     errcode = juju_to_raw1394_errcode(u->response.rcode);
> .....
> 
> Although this problem can be solved by add the offset to the pointer, but the
> member:__u32 data[0] lost its original meaning.

I don't understand what the problem is.  As long as both kernel and
library use "response.data" or "&response + offsetof(typeof(response),
data)", they will write and read at the correct location.

There would be a problem if one of the two used "&response +
sizeof(response)" instead.  Does this happen anywhere?  If so, then
these places need to be fixed, not the struct definition.
-- 
Stefan Richter
-=====-==--- -=== =--=-
http://arcgraph.de/sr/
