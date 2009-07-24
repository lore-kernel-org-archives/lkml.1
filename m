Return-Path: <linux-kernel-owner+w=401wt.eu-S1751121AbZGXECQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbZGXECQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZGXECQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:02:16 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:48270 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZGXECP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:02:15 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 00:02:15 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=BKVjhUfpiaTxQbJH/EgiIim2sL626c2JG/WZxRjE5NnzobTqxjouuNGV1QqOLeRIiK
         J8Z4dvFi1WDBrnvK1Yxo6ALrsaEEWKFv7t0yinsf5/L70WI2YbwRIYHOtfrQVCF8RS3P
         VANU/DgtE5rwivFUgRj9ZFjxZn4lyEBTbddjk=
Message-ID: <4A6930F5.3090008@gmail.com>
Date: Thu, 23 Jul 2009 20:56:37 -0700
From: "Moussa A. Ba" <moussa.a.ba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, adobriyan@gmail.com, mpm@selenic.com,
       mel@csn.ul.ie, yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com,
       moussa.a.ba@gmail.com
Subject: [PATCH 0/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the clear_refs proc interface a bit more versatile. It 
adds support for clearing either anonymous, file mapped pages or both.

echo 1 > /proc/pid/clear_refs clears ANON pages
echo 2 > /proc/pid/clear_refs clears file mapped pages
echo 3 > /proc/pid/clear_refs clears all pages

Selectively clearing pages has a measurable impact on performance as it 
decreases the number of page walks.  We have been using this interface 
and this adds flexibility to the user space application implementing the 
reference clearing.

Moussa.
