Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbXJTAe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbXJTAe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 20:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXJTAeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 20:34:20 -0400
Received: from web35709.mail.mud.yahoo.com ([66.163.179.163]:22201 "HELO
	web35709.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750817AbXJTAeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 20:34:19 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 20:34:19 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6cluAqBIAe/8vUsDx13E2oAcsWvEeaMPJGjWiEMJ4yDk8HEMEpjURR7+6twQiv+0yPltcCFb9/wThaZaAe8Silct+Jn9q8SoYFPS/u8OelNK8iq1zO+gF+gI7mY5bBihS4MjdcL39O1gnzxY5T7FWawPCQ5a60HqnlhfQxxmZk0=;
X-YMail-OSG: AUH02dEVM1lOrwlTDHK0XGPxvNiFq5jyWAhmhTsOu9sH3abje19ZeH7CkrjyN_2xaksJBBmY7vGOAJVr3UpiaVaOv3XUGkt5Myj2EXcHjwxtQ8Tygn0-
Date: Fri, 19 Oct 2007 17:27:37 -0700 (PDT)
From: Jim Brooks <jbrooks3d@yahoo.com>
Subject: Re: how to use TLB to prevent Linux accessing a particular memory region
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <754003.20445.qm@web35709.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Out of 32MB of DDR 8MB is reserved for use by DSP
> processor. But the MIPS processor downloads firmware
> into this reserved memory for the DSP.
>
> Now, is it possible to use the TLB to prevent Linux
> from accessing the reserved memory after the
firmware
> has been downloaded?

Well, even if you did remap PTEs (TLBs are N/A),
or claimed that special memory, that may be too late.
The kernel might've already allocated
and stomped over it.

A reliable way is to redefine the kernel's "memory
map"
which takes effect during boot.
Look for the memory map as a .h in arch/ (IIRC).

--
Jim Brooks


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
