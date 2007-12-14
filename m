Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbXLNGbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbXLNGbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761880AbXLNG27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:28:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:31767 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763647AbXLNG24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:28:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=elxDtNWhhQ1Y31qpTVqPRiJqUsd225r1soT9/BnHUNhf2pVdNtoHcNIe2VHRQcCmgYlWmxmpy0SNx474yKbZyKm3fB1GeTAJ3CMMF3YIuCPx76yD/n4vsjrmu6eVLan8TLh7ObhxTUoT0srPo8rhZ439k2YtWms+ZXTyLfL4y6w=
Message-ID: <4762229F.8020900@gmail.com>
Date: Fri, 14 Dec 2007 15:28:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: ATA ACPI needs "Mr interpreter, would you please shut up?" flag
References: <47620E5E.5020001@gmail.com> <4762129F.6060209@shaw.ca>
In-Reply-To: <4762129F.6060209@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>> Problem is that _GTM implementation on certain BIOSen crap themselves if
>> invoked on empty channels.  However, as written above, because initial
>> _GTM caching is done before any actual operation is performed on the
>> port, libata can't determine whether the port is occupied or not when
>> trying to cache _GTM result.  Unfortunately, VIA PATA is on both
>> categories - it needs _GTM caching but can't cope with _GTM invocation
>> on empty ports.  Yay!
> 
> I seem to have lost the thread/bug report where we decided that one
> board always choked on an empty channel. Maybe it's not that and it's
> just another case of the same issue where our resetting default timing
> values on the controller before calling _GTM would choke the _GTM method?

Could be.  Hans' machine on bug 9320 is the affected one (PATA on via
CN700).  I asked him to test the final version.  If it indeed is caused
by the same problem, there won't be evaluation failures.

Anyways, table-based implementations like the NVidia and VIA ones are
bound to fail on certain conditions.  libata reconfigures transfer mode
aggressively under certain failure conditions and _GTM invocation will
fail if the port is in a mode which is not on ACPI's mode table (which
doesn't seem to be too comprehensive anyway).  So, there's always
possibility of _GTM failure for those boards, which in turn can fail
_GTF evaluation.

As _GTM, _STM and _GTF aren't strictly necessary for operation anyway, I
think it's better to print ATA ACPI evaluation failure messages using
KERN_DEBUG.

Thanks.

-- 
tejun
