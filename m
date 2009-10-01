Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZJAVhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZJAVhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZJAVhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:37:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:7991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZJAVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:36:59 -0400
Message-ID: <4AC520F9.8000201@natemccallum.com>
Date: Thu, 01 Oct 2009 17:36:57 -0400
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Exposing device ids and driver names
References: <4AC4DB65.8070404@natemccallum.com> <20091001164249.GA2715@kroah.com> <4AC4E07E.8040707@natemccallum.com> <20091001180531.GA3199@kroah.com> <4AC4F67C.7010500@natemccallum.com> <20091001184021.GA26875@kroah.com>
In-Reply-To: <20091001184021.GA26875@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 02:40 PM, Greg KH wrote:
> On Thu, Oct 01, 2009 at 02:35:40PM -0400, Nathaniel McCallum wrote:
>> But I still would prefer a non-invasive solution.
>
> Agreed, sorry I don't have an idea on how to do it.

How about this?

-#define MODULE_GENERIC_TABLE(gtype,name)
+#define MODULE_GENERIC_TABLE(gtype,name)               \
+static const struct gtype##_id gtype##_id_table        \
+  __attribute__ ((unused, alias(__stringify(name))))

We add an alias to the existing symbol.  This just creates a new entry 
in the symbol table.  These entries are all stripped anyway and inserted 
into the System.map.

Impact:
	* No change to the resulting vmlinuz binary
	* Increases size of System.map (~2k with the Fedora config)

Nathaniel

