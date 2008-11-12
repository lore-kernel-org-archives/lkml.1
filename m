Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYKLU5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYKLU5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYKLU4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:56:55 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:53482 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752692AbYKLU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:56:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=jVgsnRhSyQpZK8vqhYNa9NhdfKJY1w50n/LSVNggEmQRYy2jPa8T5qrXDXMbk2tqj6kKCFz15iW8bWmTi6mj5LZfQHnSo9HfzJq4nvarPxs73DxqGr1Ca6Lp78keWWNA;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: pci: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Wed, 12 Nov 2008 12:56:52 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1225329469.5970.69.camel@nga.site>
In-Reply-To: <1225329469.5970.69.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121256.52644.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2008 6:17 pm Kay Sievers wrote:
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".
>
> To set and read the device name dev_name(dev) and dev_set_name(dev)
> must be used. If your code uses static kobjects, which it shouldn't
> do, "const char *init_name" can be used to statically provide the
> name the registered device should have. At registration time, the
> init_name field is cleared, to enforce the use of dev_name(dev) to
> access the device name at a later time.
>
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.
>
> We want to submit a patch to -next, which will remove bus_id from
> "struct device", to find the remaining pieces to convert, and finally
> switch over to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.

Applied to linux-next, thanks.

Jesse
