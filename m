Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYDHFO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYDHFO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 01:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYDHFOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 01:14:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51900 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYDHFOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 01:14:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 2/5] vringfd base/offset
Date: Tue, 8 Apr 2008 07:14:36 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>
References: <200804052202.09157.rusty@rustcorp.com.au> <200804052204.28518.rusty@rustcorp.com.au>
In-Reply-To: <200804052204.28518.rusty@rustcorp.com.au>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804080714.37011.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/JOJqAAtS+deB3dtP6TUnozl0wSVQH/OJTi+9
 ENFqC/Wb+bGFNneXq+8ND204PzDLqSaj6f2WJYWvO7j1a+S4fP
 G4pqyEJZKWmjOr4R0w9QA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 April 2008, Rusty Russell wrote:
>  static const struct file_operations vring_fops = {
>         .release        = vring_release,
>         .write          = vring_write,
>         .poll           = vring_poll,
> +       .ioctl          = vring_ioctl,
>  };

This should also set the .compat_ioctl pointer. If the argument 
is defined as an actual memory location instead of a pointer,
you also don't need the compat_ptr() conversion for s390x, so
both can point to the same vring_ioctl function.

	Arnd <><
