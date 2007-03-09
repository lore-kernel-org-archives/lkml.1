Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbXCIRel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbXCIRel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbXCIRel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:34:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:7775 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbXCIRej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G7mupmqae0pjw7o0Iv2l/v6UJUfoU7rAQHtcfV53eF/eI5nU8t2TT1/04tP6VYKlerQJ1vvP/WxkEQyHgDM8EVCyJWyce/IjiaaUsVRAublVTbISJwj7geHAE51guYnukzvINKC74/YLiYWzmgv7gGb5wtqyQQAHTU/GgFwwo8k=
Message-ID: <d120d5000703090934r45c39f74l2a51eda986b1f07b@mail.gmail.com>
Date: Fri, 9 Mar 2007 12:34:38 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Oliver Neukum" <oneukum@suse.de>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Maneesh Soni" <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703091818.57456.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0703091124570.2611-100000@iolanthe.rowland.org>
	 <200703091745.00169.oneukum@suse.de>
	 <d120d5000703090902v6ae88c75ibe18ff0de3e5276d@mail.gmail.com>
	 <200703091818.57456.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Oliver Neukum <oneukum@suse.de> wrote:
> Am Freitag, 9. März 2007 18:02 schrieb Dmitry Torokhov:
>
> > I think we already have all refcounting that is needed. What is
> > missing is subsystem-provided ->release() hooks for drivers to release
> > driver-specific resources when a device finally goes away.
>
> This is an interesting idea. Is it nice to pass through release()
> but not open() ?
>

Not sure if I follow... Generally speaking open is not a mandatory
operation; however every object in driver model has a release method.
What I am saying is that certain drivers need to have their disconnect
method split in 2 parts - one that shuts down the device and second is
releases resources that might be accesses through sysfs (and other
kernel parts). That second part will have to be called from
subsystem's core ->release() method se we need a release() hook.

-- 
Dmitry
