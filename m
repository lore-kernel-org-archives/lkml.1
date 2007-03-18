Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXCRGiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXCRGiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXCRGiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:38:52 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:42742 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbXCRGiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ELQypGlmWQWAw4p+3/ZS5QKeknT8k5jVtIZlD+y9vxz4CjgW8WUiWFJTMh+/erwQKgMOTsraFkoGKNoiXG7Q8ZXi3VK5dScNGKI/pkjAINIlv4jjTXa3XCPxy0IG9dc33VNulQ9ymToIaEbKwEQDSjZQa1MPxbmCopHsPJkLfCU=
Message-ID: <45FCDE73.8090002@gmail.com>
Date: Sun, 18 Mar 2007 15:38:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Conke Hu <conke.hu@gmail.com>
Subject: Re: Loading both the pata_atiixp and the ahci driver causes problems
References: <45F9C3F5.4070906@redhat.com> <45F9F5F0.3090508@jonmasters.org> <45FCD0FB.70507@gmail.com> <45FCDBFA.702@jonmasters.org>
In-Reply-To: <45FCDBFA.702@jonmasters.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jon.

Jon Masters wrote:
>> Dunno much about sb600 but ahci and pata_atiixp are probably using
>> separate IO regions && separate PCI functions.
> 
> Yeah. I actually thought about this whole issue a bit more recently -
> things like SATA/PATA interference when you've got a part that emulates
> legacy functionality so can appear as two different kinds of device -
> since I don't think my brain was really bothering to listen before.
> Words were going in, but it chose to ignore what was being said.

Dunno about the history.  Oh well, as long as the problem gets fixed.

> Only thing that comes to mind is in-driver logic/driver loading ordering
> hack combinations. At least if you've got loadable modules, you've got a
> fighting chance of fixing this kind of situation - built-in and you need
> to fight with whatever ordering exists in the array of init functions.

Not sure whether it applies to sb600 directly but libata policy for this
type of situation is..

* always prefer the native / more capable (read ahci) interface over
emulated SFF interface.

* program the device and update PCI header using a PCI quirk such that
module loading order or BIOS setting doesn't affect which driver gets
attached.  Note that if the controller needs to programmed in specific
way, the quirk also needs to be called during resume.  In this case, the
function for SFF interface can simply be disabled.

Please take a look at the JMB quirk in drivers/pci/quirks.c in the
latest libata-dev#upstream tree for details.

Thanks.

-- 
tejun
