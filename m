Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZHERqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZHERqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZHERqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:46:08 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:35820 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZHERqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:46:08 -0400
Message-ID: <4A79C4A6.9000707@csr.com>
Date: Wed, 05 Aug 2009 18:43:02 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
References: <20090805171513.GA10443@kroah.com>
In-Reply-To: <20090805171513.GA10443@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Aug 2009 17:43:02.0857 (UTC) FILETIME=[2E6CDB90:01CA15F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -929,6 +929,8 @@ int device_add(struct device *dev)
>  		error = device_create_sys_dev_entry(dev);
>  		if (error)
>  			goto devtattrError;
> +
> +		devtmpfs_create_node(dev);
>  	}
>  
>  	error = device_add_class_symlinks(dev);
[...]
> --- /dev/null
> +++ b/drivers/base/devtmpfs.c
[...]
> +int devtmpfs_create_node(struct device *dev)

Returns an int that's never checked.  Is this intentional?

> +int devtmpfs_delete_node(struct device *dev)

Similarly.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
