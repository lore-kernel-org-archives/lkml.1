Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZKCWpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZKCWpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZKCWpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:45:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbZKCWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:45:05 -0500
Date: Tue, 3 Nov 2009 14:44:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] gpiolib: fix device_create() result check
Message-Id: <20091103144401.6fa4e130.akpm@linux-foundation.org>
In-Reply-To: <200910202035.23981.sshtylyov@ru.mvista.com>
References: <200910202035.23981.sshtylyov@ru.mvista.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 20:35:23 +0400
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> In case of failure, device_create() returns not NULL but the error code.
> The current code checks for non-NULL though which causes kernel oops in
> sysfs_create_group() when device_create() fails.  Check for error using
> IS_ERR() and propagate the error value using PTR_ERR() instead of fixed
> -ENODEV code returned now...

Does anyone notice any missing information here?

/**
 * device_create - creates a device and registers it with sysfs
 * @class: pointer to the struct class that this device should be registered to
 * @parent: pointer to the parent struct device of this new device, if any
 * @devt: the dev_t for the char device to be added
 * @drvdata: the data to be added to the device for callbacks
 * @fmt: string for the device's name
 *
 * This function can be used by char device classes.  A struct device
 * will be created in sysfs, registered to the specified class.
 *
 * A "dev" file will be created, showing the dev_t for the device, if
 * the dev_t is not 0,0.
 * If a pointer to a parent struct device is passed in, the newly created
 * struct device will be a child of that device in sysfs.
 * The pointer to the struct device will be returned from the call.
 * Any further sysfs files that might be required can be created using this
 * pointer.
 *
 * Note: the struct class passed to this function must have previously
 * been created with a call to class_create().
 */


Why do we do this to ourselves?
