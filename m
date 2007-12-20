Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXLTJEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXLTJEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXLTJE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:04:28 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54111 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbXLTJE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:04:27 -0500
Date: Thu, 20 Dec 2007 10:04:26 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
In-Reply-To: <20071220003031.GA15129@kroah.com>
Message-ID: <Pine.LNX.4.64.0712200958020.18943@fbirervta.pbzchgretzou.qr>
References: <20071220003031.GA15129@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19 2007 16:30, Greg KH wrote:
>See the example module, samples/kobject/kobject-example.c for an
>implementation of a simple kobject and attributes.

Should mention here that if simple types are enough and a callback
function is not needed, a module_param() could be used instead.

>As a kset contains a kobject within it, it should always be dynamically
>created and never declared statically or on the stack.  To create a new
>kset use:
>  struct kset *kset_create_and_add(char *name,
>				   struct kset_uevent_ops *u,
>				   struct kobject *parent);
Hmm... Not const char *?

>If a kset wishes to control the uevent operations of the kobjects
>associated with it, it can use the struct kset_uevent_ops to handle it:
>
>struct kset_uevent_ops {
>        int (*filter)(struct kset *kset, struct kobject *kobj);
>        const char *(*name)(struct kset *kset, struct kobject *kobj);
>        int (*uevent)(struct kset *kset, struct kobject *kobj,
>                      struct kobj_uevent_env *env);
>};
>
>
>The filter function allows a kset to prevent a uevent from being emitted to
>userspace for a specific kobject.  If the function returns 0, the uevent
>will not be emitted.
>
What about other return values? Should filter perhaps return bool instead?

