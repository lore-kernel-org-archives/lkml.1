Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZITHrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZITHrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 03:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZITHro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 03:47:44 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:34972 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZITHrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 03:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=H7UsFF1dnMy5ui7BzSvGo9MTeeR9Qewneio/yjzpAD7EYMlG/GlZH0cItKxImZyyQa
         pJsNFDQRi0b/uim7GlEwvMXwmUcHzxHjdX0Q0KqTOwUHo1gBPQ+xgDvX6WusE6ci7Z+U
         +dEKA4JLf9ywFRabUn15c95Ln47WfPgOdoLr8=
Message-ID: <4AB5DE1F.1020004@gmail.com>
Date: Sun, 20 Sep 2009 01:47:43 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
CC: r.marek@assembler.cz
Subject: coretemp support for Core i5 CPU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to load the coretemp driver for CPU temperature monitoring on a 
Core i5 750 CPU gives:

coretemp: Unknown CPU model 1e
coretemp: Unknown CPU model 1e
coretemp: Unknown CPU model 1e
coretemp: Unknown CPU model 1e

Looks like this model needs to be added to the list in 
drivers/hwmon/coretemp.c. Though this doesn't really seem like a very 
good approach as we'll keep having to update this driver whenever a new 
CPU model gets released. Intel has a CPUID field that indicates if the 
thermal sensor is supported: "The processor supports a digital thermal 
sensor if CPUID.06H.EAX[0] = 1." We should likely be using this instead 
of hard-coded CPU model checks..
