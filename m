Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZHTU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZHTU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZHTU6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:58:21 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:35081 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbZHTU6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tudp0EVAt/Ioiz9VCazn4Z16KQhpobwAmDFf7DC1HqOFCENv+WSwyuSqK5jOulEL+w
         LVrK0eHxMlyxkfnPsuqq/zYunhPE7JilGeyzjSGHMzNThaZVLVjH5kCf4gsMOp6/4Bmc
         pO4Jg4f1ZiImTJJCdcbP5oUgGel0miUbI/TJg=
MIME-Version: 1.0
In-Reply-To: <4A8C627C.70001@redhat.com>
References: <20090814154125.26116.70709.stgit@dev.haskins.net>
	 <20090817150844.GA3307@elte.hu> <4A89B08A.4010103@gmail.com>
	 <4A8A674E.8070200@redhat.com> <4A8ABEC9.6090006@gmail.com>
	 <4A8AD678.7050609@redhat.com> <4A8B9B79.9050004@gmail.com>
	 <4A8BA5AE.3030308@redhat.com> <4A8C43D3.7030002@gmail.com>
	 <4A8C627C.70001@redhat.com>
Date: Thu, 20 Aug 2009 13:58:20 -0700
Message-ID: <469958e00908201358q6128aefay4251873dbb44097c@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for vbus_driver 
	objects
From: Caitlin Bestler <caitlin.bestler@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Patrick Mullaney <pmullaney@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 1:37 PM, Avi Kivity<avi@redhat.com> wrote:

>
> Well I'm not an Infiniband expert.  But from what I understand VMM bypass
> means avoiding the call to the VMM entirely by exposing hardware registers
> directly to the guest.
>

It enables clients to talk directly to the hardware. Whether or not
that involves
registers would be model specific. But frequently the queues being written
were in the client's memory, and only a "doorbell ring" involved actual device
resources.

But whatever the mechanism, it enables the client to provide buffer addresses
directly to the hardware in a manner that cannot damage another client. The two
key requirements are a) client cannot enable access to pages that it does
not already have access to, and b) client can delegate that authority to the
Adapter without needing to invoke OS or Hypervisor on a per message
basis.


Traditionally that meant that memory maps ("Regions") were created on the
privileged path to enable fast/non-privileged references by the client.
