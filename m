Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXLTHyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXLTHyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXLTHyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:54:43 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:1149 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751959AbXLTHym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:54:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LdRPfGV1WGs4PN0uEZHZqISpZvxnxh+U7x4zKtCrkq5nrZ7d+BXo/eEuPt1iab70XvyZVnexafNrnZeoYGyiQ/pOZJmw2tm/N6ms8+3QsH/7ieW2gfl3KphdQHz7SdBv3aALp0GHUd90Km53bGrJfZLixQjuN3ByIuIOX6LEuXg=
Message-ID: <a8e1da0712192354k3bce177fi3d30b5737c7d7a9e@mail.gmail.com>
Date: Thu, 20 Dec 2007 15:54:40 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Cc: linux-kernel@vger.kernel.org, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Jonathan Corbet" <corbet@lwn.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <20071220003031.GA15129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220003031.GA15129@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 8:30 AM, Greg KH <greg@kroah.com> wrote:
> Thanks to everyone for your last round of review comments and changes to
> the kobject documentation.
>
> I now have over 130 patches reworking the kset/ktype and kobject apis in
> the kernel tree, and here is the updated documentation and example code
> that shows how things work now.
>
> Things different from the last time around are the kobject_add() and
> kobject_init() functions now take a bunch of required parameters, and
> the kobject cleanup code is much more forgiving.
>
> I want to drop kobject_unregister() but as this patch series is so big
> already, I think it's time to let it bake in -mm and push into 2.6.25
> before attempting it.
[--snip--]

Hi, greg

How about add a kobject_remove function and temporarily keep the
kobject_unregister as below until the 2.6.25:

kobject_unregister(...)
{
       ...
        kobject_remove();
        kobject_uevent();
        ...
}
