Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbYAUFqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbYAUFqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 00:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYAUFqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 00:46:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYAUFqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 00:46:08 -0500
Message-ID: <47943186.8030001@cn.fujitsu.com>
Date: Mon, 21 Jan 2008 13:45:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Thomas, Sujith" <sujith.thomas@intel.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       sam@ravnborg.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/10] introduce intel_menlow platform specific driver
References: <1200556278.2935.118.camel@acpi-sony.sh.intel.com>	 <20080117092030.a9dfe528.randy.dunlap@oracle.com> <1200627175.2935.174.camel@acpi-sony.sh.intel.com> <4790231C.1040805@cn.fujitsu.com> <05B550FD4BD2014E841D83547B6260080281A8A8@bgsmsx411.gar.corp.intel.com>
In-Reply-To: <05B550FD4BD2014E841D83547B6260080281A8A8@bgsmsx411.gar.corp.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +static int __init intel_menlow_module_init(void)
>>> +{
>>> +	int result = -ENODEV;
>>> +	acpi_status status;
>>> +	unsigned long enable;
>>> +
>>> +	if (acpi_disabled)
>>> +		return result;
>>> +
>>> +	/* Looking for the \_TZ.GSTS method */
>>> +	status = acpi_evaluate_integer(NULL, BIOS_ENABLED, NULL, &enable);
>>> +	if (ACPI_FAILURE(status) || !enable)
>>> +		return -ENODEV;
>>> +
>>> +	/* Looking for ACPI device MEM0 with hardware id INT0002 */
>>> +	result = acpi_bus_register_driver(&intel_menlow_memory_driver);
>>> +	if (result)
>>> +		return result;
>>> +
>>> +	/* Looking for sensors in each ACPI thermal zone */
>>> +	status = acpi_walk_namespace(ACPI_TYPE_THERMAL, ACPI_ROOT_OBJECT,
>>> +				     ACPI_UINT32_MAX,
>>> +				     intel_menlow_register_sensor, NULL, NULL);
>>> +	if (ACPI_FAILURE(status))
>>> +		result = -ENODEV;
>>> +
>> It seems to me this should be 'return -ENODEV;'
>>
>> You can just eliminate variable result, because result will be
>> -ENODEV only.
> I disagree. "result" is required to store the return value from acpi_bus_register_driver which may be different from ENODEV. Otherwise it's all -ENODEV.
> 
> :-Sujith

Indead, I overlooked it.

But the above 'result = -ENODEV;' should be 'return -ENODEV;', right?

>>> +	return 0;
>>> +}

