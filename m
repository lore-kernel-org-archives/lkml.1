Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYJQBbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYJQBbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYJQBbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:31:40 -0400
Received: from web32407.mail.mud.yahoo.com ([68.142.207.200]:32147 "HELO
	web32407.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751013AbYJQBbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:31:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=WXq5iR2JOk33cPs/UaMrxaIQv56wKOBB8YmX31eh5RBJsMlcWnm0xvj0elSI36KXWXf5Z0IPSFNX8JSbJzHEYhSEfLwYcvNP3+Eh/dPF8alaRn1gctFk8fg50KLeyDPM43+u+cYZDwsHA4lT+7SDNoQeTm7k37YyLU0WEPGqveg=;
X-YMail-OSG: vad8vywVM1n6_YZnhOrwR7kVndpzCaMIDNMi0dWrx1mtg7tA5aOnVpSPGV4lzKCP3Chn0p7FgUJ_VhuiOyI3mK8ehSazkRJGhAggrjruXVhfz1MwxbqMmyrfTdRbrergRLyfAk3jTKox3thGEoFf5DTUBikgJtEZNrWQe9A-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Thu, 16 Oct 2008 18:31:38 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Reply-To: anils_r@yahoo.com
Subject: MSI-X msix_entry.vector population
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <886149.56834.qm@web32407.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the driver, during interrupt registration for MSIX we get the vector numbers assigned from the kernel and we associate the entry and interrupt handlers with this vector.

I want to achieve the following logic in the driver:
In the queuecommand I assign MSIX vector for each command before sending it down. The reason why I want to do this is I want to get the response back in that particular MSIX vector entry interrupt handler only. For example If I am sending two commands down, command1 will have MSIX_vector_1 and command2 will have MSIX_vector_2. The interrupt handlers registered are MSIX_vector_1_Int1 and MSIX_vector_2_Int2. When command is complete the response should come back in the respective interrupt handlers registered for MSIX_vector_1 and MSIX_vector_2 only. 

To achieve this, I will take msix_entries.[1].vector and assign it to command1 in queuecommand and msix_entries.[2].vector and assign it to command2.

Question:
Now if I have a Dual core CPU, CORE1 and CORE2 each with vectors 0 to 4 on them. When I shoot a command with msix_entries[1].vector will the completion for this command come from CORE1 core vector1 or it can come from CORE2 vector1. Is it okay if we get response(triggered interrupt handler) back from CORE2. Will I have any routing issues here?

-or- 

Is there a way wherein I can call some function to make sure that let the kernel assign MSIX.vector for my command in proper distributed way in my queuecommand.

with regards,
  Anil

 


      
