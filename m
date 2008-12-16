Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYLPSmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYLPSmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYLPSmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:42:13 -0500
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:44899 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751689AbYLPSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:42:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=r558dQq+qqkFyxWum969wE5UNHhYqwBh0W+5xxBtyMmoZLLzM8KeSkGAFiBPLO0aKt3ev/m/kiRbciL1/9rpi/Q69uvyJJC7lZkcYswMPuMd82iZXIumOU0U0Ut/Halv;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] ibmphp: Fix module ref count underflow
Date: Tue, 16 Dec 2008 10:42:08 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: greg@kroah.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20081210194334.GA25257@hmsreliant.think-freely.org>
In-Reply-To: <20081210194334.GA25257@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161042.09345.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 10, 2008 11:43 am Neil Horman wrote:
> Hey-
> 	I happened to notice that the ibmphp hotplug driver does something
> rather silly in its init routine.  It purposely calls module_put so as to
> underflow its module ref count to avoid being removed from the kernel. 
> This is bad practice, and wrong, since it provides a window for subsequent
> module_gets to reset the refcount to zero, allowing an unload to race in
> and cause all sorts of mysterious panics.  If the module is unsafe to load,
> it should inform the kernel as such with a call to __unsafe.  The patch
> below does that.

Thanks Neil, applied this to my for-linus branch since it sounds potentially 
serious (but also low risk since who uses ibmphp anymore? :)

Jesse
