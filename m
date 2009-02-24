Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbZBXTNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbZBXTNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZBXTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:13:09 -0500
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:51527 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753344AbZBXTNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:13:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=pMUdQriGfIJ6A/pbBT4TjevnIMtDsa96XqKaV/TDNT4r7bJv9MXblZF4IjsWmaYz7OiiaIBXPoUuKlpXxO14iwrBMPioMWaN3K0T6lus6rJsc9nqVWSitB0jq4WiH4s4;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove (take 2)
Date: Tue, 24 Feb 2009 11:12:58 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1ocx5ve8o.fsf@fess.ebiederm.org> <200902201153.52683.rjw@sisk.pl> <m1r61s2znc.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1r61s2znc.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241112.59203.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 20, 2009 8:16:07 pm Eric W. Biederman wrote:
> pcie_port_device_remove currently calls the remove method of port
> drivers twice.  Ouch!
>
> We are calling device_for_each_child multiple times for no apparent
> reason.
>
> So make it simple. Place put_device and device_unregister into
> remove_iter, and throw out the rest.  Only call device_for_each_child
> once.
>
> The code is simpler and actually works!
>
> Changelog:
> v2 rebase against the linux-next tree so I don't conflict with Rafael's
>    irq work, and remove the irq handling cleanups as Rafael's patch already
>    made them.

Thanks for rebasing; it's queued up in my linux-next branch now.  If we really 
need this in the stable kernel it'll be a bit painful, since some of these 
structures have changed around a bit...

-- 
Jesse Barnes, Intel Open Source Technology Center
