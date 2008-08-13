Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYHMHQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYHMHQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYHMHQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:16:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:37325 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbYHMHQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xKAEzKWb2HZ9y5ttp8yGgUeqKKmh8K4BHv1vBCfn/1CDxfabekEII/OMZTIZcmKNzb
         ZkLxGdzVUuw4v8nHCXo5QCvkN13coVorEv31oi7wLlMJGKOhWHiOq0t144TqmzKjcgWZ
         JBAv3eQho/VJydufI6tIzdw1uCKDoMy1PFhqU=
Message-ID: <ea8d860a0808130016w646307few3cc6385caf9b1ec7@mail.gmail.com>
Date: Wed, 13 Aug 2008 08:16:02 +0100
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Intel Management Engine Interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080813005835.GE22793@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl>
	 <20080813005835.GE22793@kroah.com>
X-Google-Sender-Auth: c1bd1cb531dcf11d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/13 Greg KH <greg@kroah.com>:
> On Mon, Aug 11, 2008 at 09:23:01PM +0200, Marcin Obara wrote:
>> +/* IOCTL commands */
>> +#define IOCTL_HECI_GET_VERSION \
>> +    _IOWR('H' , 0x0, struct heci_message_data)
>
> This can easily be a sysfs file, why not do that instead?
>
sysfs file would require additional file handle used by every userspace client.
GET_VERSION is called frequently, and sysfs file would create extra overhead.
With ioctl - only one file handle is used, and userspace client logic
is simpler.
Normal flow looks like:

open
ioctl(GET_VERSION)
ioctl(CONNECT)
... - do some operations - depends on version
close

or:

open
ioctl(CONNECT)
.. - do some operations
close


-- 
Marcin
