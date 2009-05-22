Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbZEVWDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbZEVWDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZEVWDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:03:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36777 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbZEVWDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:03:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A172131.5010005@s5r6.in-berlin.de>
Date: Sat, 23 May 2009 00:03:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] firewire: core: add sysfs attribute for easier udev
 rules
References: <tkrat.d86e749d664670a9@s5r6.in-berlin.de> <ac3eb2510905211001m77eda9e4gb73001d504fd5376@mail.gmail.com>  <4A159899.20506@s5r6.in-berlin.de> <4A165CED.8030601@s5r6.in-berlin.de> <ac3eb2510905220423h23e7aca1u3bc7c204db551eb0@mail.gmail.com> <tkrat.7b837daea0cfa5b2@s5r6.in-berlin.de> <tkrat.acafb37c21e20784@s5r6.in-berlin.de>
In-Reply-To: <tkrat.acafb37c21e20784@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> +	while (fw_csr_iterator_next(&ci, &key, &value)) {
> +		if (key != (CSR_UNIT | CSR_DIRECTORY))
> +			continue;
> +		i += units_sprintf(&buf[i], ci.p + value - 1);
> +		if (i >= PAGE_SIZE - (8 + 1 + 8 + 1))
> +			break;
> +	}
> +	up_read(&fw_device_rwsem);
> +
> +	sprintf(&buf[i ? i - 1 : 0], "\n");

Rather:
	if (i)
		buf[i - 1] = '\n';
> +
> +	return i;
> +}
-- 
Stefan Richter
-=====-==--= -=-= =-===
http://arcgraph.de/sr/
