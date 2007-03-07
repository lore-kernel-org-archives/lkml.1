Return-Path: <linux-kernel-owner+w=401wt.eu-S1422736AbXCGQ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422736AbXCGQ7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422738AbXCGQ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:59:39 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:16080 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422736AbXCGQ7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:59:39 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Date: Wed, 7 Mar 2007 17:59:28 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Oliver Neukum <oliver@neukum.name>,
       Maneesh Soni <maneesh@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com> <d120d5000703070756v4fe11a54u9009d3efd93faa9d@mail.gmail.com> <Pine.LNX.4.64.0703070845500.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703070845500.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703071759.29522.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH/11jSg2To
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. März 2007 17:52 schrieb Linus Torvalds:
> 
> On Wed, 7 Mar 2007, Dmitry Torokhov wrote:
> > 
> > ... with the exception that it will again make data associated with
> > sysfs attributes accessible past the point of returning from
> > sysfs_remove_file. And that was the point so drivers would not have to
> > care about handling access to extra data (such as static strings) past
> > the driver unload.
> 
> Drivers are unloaded by stopping the whole machine (exactly because module 
> unload is otherwise so hard to handle), so that never happens unless you 
> actively block. In other words, if you do something as simple as

The problem also exists with unplugging devices. Drivers get no feedback
to tell them when it is safe to free the data structures associated with
an attribute.

	Regards
		Oliver
