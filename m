Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903Ab0ADT5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0ADT5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045Ab0ADT5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:57:08 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:42955 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0ADT5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:57:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=ba1sKVPxkKjbMMuiyaWsr9gg8dVnVEAhUwDXa7G1wUWe/hiRyiB8oiEZC7essrb7tm
         Z/LSLMZJm5DLz0g6c3gzvwdZ2CvkLJfpehl16LWs5SyeNz0dLLFr2Bs+r0lpCtwo/NoQ
         h+BK+PVz2OpgLkjbKuUljIM4M8PXatGOl/rxU=
Subject: Re: [block subsystem] Need help to prevent races on unexpected
 device removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1262546027.4555.17.camel@maxim-laptop>
References: <1262546027.4555.17.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 21:56:57 +0200
Message-ID: <1262635017.10523.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-03 at 21:13 +0200, Maxim Levitsky wrote: 
> During development of hotplug support for mtd translation layer I seems
> to be unable to figure a way to prevent following race:
> 
> First of all, a block device is registered. I attach a private structure
> to that device to save all internal information.
> 
> Then out of the blue (when user pulls off the card) I receive a request
> to remove the device.
> 
> In the function that handles such removal, I do:
> 
> del_gendisk(...
> blk_start_queue
> 
> stop thread that processes the requests
> 
> blk_cleanup_queue(old->rq);
> 
> 
> The problem is that I don't know where/when to free the private
> structure.
> 
> I though about adding a field to the structure, with name 'invalid', so
> that release will not attempt to go futher, but free the structure, but
> what happens if release is never called?
> In other words this will work as long as there is a user of the block
> device.
> 
> I thought then that I can detect that condition and free the structure
> in the removal function itself, but then I get a race with ->open
> running in same time, and mutex will not prevent it, I will have to
> release it somewhen, and then ->open will access a freed structure....
> 
> 
> Best regards,
> Maxim Levitsky
> 

Still don't know how to do that properly....

Best regards,
Maxim Levitsky

