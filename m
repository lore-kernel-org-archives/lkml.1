Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbXJZQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbXJZQ7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbXJZQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:59:22 -0400
Received: from palrel12.hp.com ([156.153.255.237]:39117 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760187AbXJZQ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:59:18 -0400
Message-ID: <47221CE4.70103@hp.com>
Date: Fri, 26 Oct 2007 09:59:16 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Gaurav Aggarwal <grv.aggarwal@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidsen@tmr.com
Subject: Re: Bad TCP checksum error
References: <1a41e0840710260041u4ebeb1e3h521e740a78f7e0bf@mail.gmail.com> <1a41e0840710260903w33516f62kc53e5eb56e424d69@mail.gmail.com>
In-Reply-To: <1a41e0840710260903w33516f62kc53e5eb56e424d69@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Checksum Offload on the NIC(s) can complicate things.  First, if you are tracing 
on the sender, the tracepoint is before the NIC has computed the full checksum. 
  IIRC only a partial checksum is passed-down to the NIC when CKO is in use.

So, making certain your trace is from the "wire" or the receiver rather than the 
sender would be a good thing, and trying again with CKO disabled on the 
interface(s) (via ethtool) might be something worth looking at.  Ultimately, 
doing the partial checksum modificiations in a CKO-friendly manner might be a 
good thing.

rick jones
